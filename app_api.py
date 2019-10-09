from flask import Flask, request
from flask_mail import Mail, Message
from flask_mysqldb import MySQL
from flask_restful import Resource, Api
from datetime import datetime

app = Flask(__name__)

app.config['TESTING'] = True

# Untuk buat API
api = Api(app)

# Untuk kirim email

app.config['MAIL_DEFAULT_SENDER'] = ("Banking TNIS", "banking.api.tnis@gmail.com")
app.config['MAIL_DEBUG'] = False
app.config['MAIL_SUPPRESS_SEND'] = False
app.config['MAIL_SERVER']='smtp.gmail.com'
app.config['MAIL_PORT']= 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USE_SSL']= False
app.config['MAIL_USERNAME'] = 'banking.api.tnis@gmail.com'
app.config['MAIL_PASSWORD'] = 'tnis12345'
mail = Mail(app)

# Untuk koneksi ke database MySQL di phpmyadmin
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'banking_api'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor' # dipake supaya pas fetch data bisa pake nama kolom db
mysql = MySQL(app)

# REST API

class Users(Resource):
    def post(self):
        req_json = request.get_json()

        name = req_json['name']
        phone_num = req_json['phone_number']
        email = req_json['email']
        address = req_json['address']
        id_role = req_json['role']

        # cek dulu udah ada belum email dan no telp nya
        cur = mysql.connection.cursor()
        cek_email_sql = ("SELECT email FROM users WHERE email ='" + email +"'")
        cur.execute(cek_email_sql)
        hasil_email = cur.fetchall()

        cek_nohp_sql = ("SELECT phone_number FROM users WHERE phone_number='"+ phone_num +"'")
        cur.execute(cek_nohp_sql)
        hasil_nohp = cur.fetchall()
        cur.close()

        if(len(hasil_email) > 0 and len(hasil_nohp) == 0): # kalo email uda terdaftar tp no hp ngga
            res_json = {
                'response_msg' : 'Your email was registered. Please change your email.',
                'response_code' : -1406
            }
        elif(len(hasil_email) == 0 and len(hasil_nohp) > 0): # kalo no hp udah terdaftar tp email ngga
            res_json = {
                'response_msg' : 'Your phone number was registered. Please change your phone number.',
                'response_code' : -1407
            }
        elif(len(hasil_email) > 0 and len(hasil_nohp) > 0): # kalo no hp dan email ud terdaftar
            res_json = {
                'response_msg' : 'Your phone number and email were registered. Please use another email and phone number.',
                'response_code' : -1408
            }
        else:
            cur = mysql.connection.cursor()
            result = cur.execute("INSERT INTO users (name, email, phone_number, address, id_role) VALUES(%s, %s, %s, %s, %s)", (name, email, phone_num, address, id_role))
            cur.close()
            mysql.connection.commit()
        
            if(result):
                res_json = {
                    'response_msg' : 'OK',
                    'response_code' : 0
                }
            else:
                res_json = {
                    'response_msg' : 'Failed to create resource',
                    'response_code' : -1405
                }
        
        return res_json

class Transactions(Resource):
    def post(self):
        req_json = request.get_json()

        amount = req_json['amount']
        account_num_recipient = req_json['account_num_recipient']
        sender_name = req_json['sender_name']
        sender_phone_num = req_json['sender_phone_num']
        sender_email = req_json['sender_email']
        id_tran_cat = req_json['id_tran_cat']
        id_tran_type = req_json['id_tran_type']
        description = req_json['description']
        transaction_date = req_json['transaction_date']
        transaction_status = '1'

        cur = mysql.connection.cursor()
        query_insert = "INSERT INTO transactions (amount, account_num_recipient, sender_name, sender_phone_num, id_tran_cat, id_tran_type, description, transaction_date, transaction_status) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"
        result_insert = cur.execute(query_insert, (amount, account_num_recipient, sender_name, sender_phone_num, id_tran_cat, id_tran_type, description, transaction_date, transaction_status))
        
        query_update = "UPDATE accounts set balance = balance + %s WHERE account_number = %s"
        result_update = cur.execute(query_update, (amount, account_num_recipient))
        
        cur.close()
        mysql.connection.commit()

        if(result_insert and result_update):

            # notifikasi ke email customer
            send_email_notif = EmailNotification(sender_email, amount, transaction_date)
            send_email_notif.send_message()

            if(send_email_notif):
                res_json = {
                    'response_msg' : 'OK',
                    'response_code' : 0
                }
            else:
                res_json = {
                    'response_msg' : 'Failed sending email',
                    'response_code' : -999
                }

        else:
            res_json = {
                'response_msg' : 'Failed to create resource',
                'response_code' : -1405
            }
        
        return res_json
    
    def get(self, id_user):
        cur = mysql.connection.cursor()

        # query = ("SELECT id_transaction, account_num_sender, account_num_recipient, sender_name, sender_phone_num, tran_cat_name, tran_type_name, " +
        #         "transaction_date, transaction_status " +
        #         "FROM transactions NATURAL JOIN transactions_category NATURAL JOIN transactions_type "
        #         "WHERE account_num_recipient = '" + account_number +"'")

        query = ("SELECT id_transaction, account_num_sender, account_num_recipient, sender_name, sender_phone_num, tran_cat_name, tran_type_name, " +
                    "transaction_date, transaction_status " +
                    "FROM transactions NATURAL JOIN transactions_category NATURAL JOIN transactions_type " +
                    "WHERE account_num_recipient IN (SELECT account_number FROM accounts WHERE id_user ='"+ id_user +"')")

        result = cur.execute(query)
        data = cur.fetchall()
        cur.close()

        if(len(data) == 0):
            res_json = {
                'response_msg' : 'Tidak ada data transaksi',
                'response_code' : -1409
            }
        else:
            history = {}
            history_data = [] 
            for row in data:
                for attr in row:
                    if(attr == 'transaction_date'): # kalo date harus diubah jadi string
                        tran_date = row[attr] # ambil date nya
                        tran_date_str = tran_date.strftime("%d %b, %Y")
                        row[attr] = tran_date_str
                    
                history_data.append(row)
            
            history['data'] = history_data
            history['response_code'] = 0
            history['response_msg']  = 'OK'
        
        return (history)

class EmailNotification:
    def __init__(self, recipient, amount, transaction_date):
        self.amount = amount
        self.recipient = recipient
        self.transaction_date = transaction_date

    def send_message(self):
        
        msg = Message(subject="Cash Depost Transaction Notification", recipients=[self.recipient])
        msg.body = ("Hi, your cash deposit transaction with the amount of Rp. "+ str(self.amount) +" on " + str(self.transaction_date) + " success. Thank you for using our bank. ")
        mail.send(msg)
        mail.send(msg)

        return True

api.add_resource(Users, '/api/users')
api.add_resource(Transactions, '/api/transactions', '/api/transactions/<id_user>')

if __name__ == '__main__':
    app.run()

import json
import unittest
import pytest
from app_api import app
import requests

class TestBankingApi(unittest.TestCase):
    '''
    Unit testing for Banking Api
    1. Test when creating customer (phone number udah ada)
    2. Test when creating cash deposit transaction
    3. Test when get history cash deposit transaction by Customer ID
    '''
    def setUp(self):
        self.app = app
        self.client = self.app.test_client()
        self.data_customer = {
            "name" : "Cindy",
            "email" : "cndywinata@gmail.com",
            "phone_number" : "081212630097",
            "address" : "Jakarta",
            "role" : "CST"
        }
        self.data_cash_deposit_tran = {
            "amount" : 55000,
            "account_num_recipient" : "8870076135",
            "sender_name" : "Yohana",
            "sender_phone_num" : "081212630097",
            "sender_email" : "renmeilla19@gmail.com",
            "id_tran_cat" : "CAD",
            "id_tran_type" : "C",
            "description" : "hello",
            "transaction_date" : "2019-10-08 00:00:00"
        }
        self.data_get_history = {
            "id_user" : "1"
        }
    
    def test_create_customer(self):
        resp = self.client.post(path='/api/users', data=json.dumps(self.data_customer), content_type="application/json").get_json()
        self.assertEqual(resp['response_code'], -1407)
    
    def test_create_cash_deposit_transaction(self):
        resp = self.client.post(path='/api/transactions', data=json.dumps(self.data_cash_deposit_tran), content_type="application/json").get_json()
        self.assertEqual(resp['response_code'], 0)

    def test_get_history_cash_deposit_transaction(self):
        id_user = self.data_get_history['id_user']
        path_get = '/api/transactions/{}'.format(id_user)
        resp = self.client.get(path=path_get, content_type="application/json").get_json()
        self.assertEqual(resp['response_code'], 0)

if __name__ == '__main__':
    unittest.main()
    

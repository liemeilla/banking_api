# Banking Api

This is a banking RESTful APIs mainly for simple banking operation such as:
* Creating customers
* Creating cash deposit transactions for customer by bank officer
* Get the history of customer for their cash deposit by bank officer 

This API consists of **Users** and **Transactions**. Users represents all the information about the general user such as name, address, phone number and email. For the Transactions, it fouces about storing transaction information such as amount, the account number recipients and others. 

This Bangking RESTful APIs used `flask` python framework and for the unit testing used `nose`. For the database we used MySQL in phpmyadmin. Other libraries which been used:
* flask-restful
* flask-mysql
* flask-mail
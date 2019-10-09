-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 09, 2019 at 06:05 PM
-- Server version: 10.1.25-MariaDB
-- PHP Version: 5.6.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `banking_api`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `account_number` varchar(10) NOT NULL,
  `balance` double NOT NULL,
  `id_user` int(11) NOT NULL,
  `account_status` char(1) NOT NULL,
  `account_created_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`account_number`, `balance`, `id_user`, `account_status`, `account_created_date`) VALUES
('2313213123', 1000000, 1, '1', '2019-10-08 00:00:00'),
('4670191911', 2000000, 3, '1', '2019-10-08 00:00:00'),
('8870076135', 1993000, 1, '1', '2019-10-09 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id_role` varchar(3) NOT NULL,
  `role_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id_role`, `role_name`) VALUES
('BKO', 'Bank Officer'),
('CST', 'Customer');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id_transaction` int(11) NOT NULL,
  `amount` double NOT NULL,
  `account_num_recipient` varchar(10) NOT NULL,
  `account_num_sender` varchar(10) DEFAULT NULL,
  `sender_name` varchar(50) NOT NULL,
  `sender_phone_num` varchar(13) NOT NULL,
  `sender_email` varchar(50) NOT NULL,
  `id_tran_cat` varchar(3) NOT NULL,
  `id_tran_type` char(1) NOT NULL,
  `description` varchar(100) NOT NULL,
  `transaction_date` datetime NOT NULL,
  `transaction_status` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id_transaction`, `amount`, `account_num_recipient`, `account_num_sender`, `sender_name`, `sender_phone_num`, `sender_email`, `id_tran_cat`, `id_tran_type`, `description`, `transaction_date`, `transaction_status`) VALUES
(21, 40000, '8870076135', NULL, 'Yohana', '081212630097', '', 'CAD', 'C', 'hello', '2019-10-08 00:00:00', '1'),
(22, 98000, '8870076135', NULL, 'Yohana', '081212630097', '', 'CAD', 'C', 'hello', '2019-10-08 00:00:00', '1'),
(23, 55000, '8870076135', NULL, 'Yohana', '081212630097', '', 'CAD', 'C', 'hello', '2019-10-08 00:00:00', '1');

-- --------------------------------------------------------

--
-- Table structure for table `transactions_category`
--

CREATE TABLE `transactions_category` (
  `id_tran_cat` varchar(3) NOT NULL,
  `tran_cat_name` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transactions_category`
--

INSERT INTO `transactions_category` (`id_tran_cat`, `tran_cat_name`) VALUES
('CAD', 'Cash Deposit');

-- --------------------------------------------------------

--
-- Table structure for table `transactions_type`
--

CREATE TABLE `transactions_type` (
  `id_tran_type` char(1) NOT NULL,
  `tran_type_name` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transactions_type`
--

INSERT INTO `transactions_type` (`id_tran_type`, `tran_type_name`) VALUES
('C', 'Credit'),
('D', 'Debit');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id_user` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `phone_number` varchar(13) NOT NULL,
  `email` varchar(50) NOT NULL,
  `address` varchar(100) NOT NULL,
  `id_role` varchar(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id_user`, `name`, `phone_number`, `email`, `address`, `id_role`) VALUES
(1, 'Bella', '081212630097', 'renmeilla19@gmail.com', 'Mega Kebon Jeruk, Jakarta Barat', 'CST'),
(2, 'Margaret', '081212629329', 'hello@floustudio.com', 'Meruya', 'BKO'),
(3, 'Tommy', '081212628928', 'tommy@gmail.com', 'Ciledug', 'CST'),
(4, 'hello', '0912812910', 'eee@gmail.com', 'Jakarta', 'CST');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`account_number`),
  ADD KEY `FK_accounts_users` (`id_user`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_role`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id_transaction`),
  ADD KEY `FK_trans_transcat` (`id_tran_cat`),
  ADD KEY `FK_trans_user_sender` (`account_num_sender`),
  ADD KEY `FK_trans_transtype` (`id_tran_type`),
  ADD KEY `FK_trans_user_recipient` (`account_num_recipient`);

--
-- Indexes for table `transactions_category`
--
ALTER TABLE `transactions_category`
  ADD PRIMARY KEY (`id_tran_cat`);

--
-- Indexes for table `transactions_type`
--
ALTER TABLE `transactions_type`
  ADD PRIMARY KEY (`id_tran_type`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id_user`),
  ADD KEY `FK_users_roles` (`id_role`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id_transaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `accounts`
--
ALTER TABLE `accounts`
  ADD CONSTRAINT `FK_accounts_users` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`);

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `FK_trans_transcat` FOREIGN KEY (`id_tran_cat`) REFERENCES `transactions_category` (`id_tran_cat`),
  ADD CONSTRAINT `FK_trans_transtype` FOREIGN KEY (`id_tran_type`) REFERENCES `transactions_type` (`id_tran_type`),
  ADD CONSTRAINT `FK_trans_user_recipient` FOREIGN KEY (`account_num_recipient`) REFERENCES `accounts` (`account_number`),
  ADD CONSTRAINT `FK_trans_user_sender` FOREIGN KEY (`account_num_sender`) REFERENCES `accounts` (`account_number`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `FK_users_roles` FOREIGN KEY (`id_role`) REFERENCES `roles` (`id_role`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- phpMyAdmin SQL Dump
-- version 5.0.4deb2ubuntu5
-- https://www.phpmyadmin.net/
--
-- Host: boxbilling.org:3306
-- Generation Time: Oct 23, 2021 at 01:35 PM
-- Server version: 10.5.12-MariaDB-1build1
-- PHP Version: 7.4.25

--
-- Structure dump of BoxBilling.
-- Importing only this file is not enough.
-- You have to import content.sql after importing this.
-- Thanks for using BoxBilling!
--
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `boxbilling`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_admin_history`
--

CREATE TABLE `activity_admin_history` (
  `id` bigint(20) NOT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `activity_client_email`
--

CREATE TABLE `activity_client_email` (
  `id` bigint(20) NOT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `sender` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `recipients` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content_html` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content_text` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `activity_client_history`
--

CREATE TABLE `activity_client_history` (
  `id` bigint(20) NOT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `activity_system`
--

CREATE TABLE `activity_system` (
  `id` bigint(20) NOT NULL,
  `priority` tinyint(4) DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `message` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` bigint(20) NOT NULL,
  `role` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT 'staff' COMMENT 'admin, staff',
  `admin_group_id` bigint(20) DEFAULT 1,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pass` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `salt` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `signature` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `protected` tinyint(1) DEFAULT 0,
  `status` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT 'active' COMMENT 'active, inactive',
  `api_token` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `permissions` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `admin_group`
--

CREATE TABLE `admin_group` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `api_request`
--

CREATE TABLE `api_request` (
  `id` bigint(20) NOT NULL,
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `request` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` bigint(20) NOT NULL,
  `session_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency_id` bigint(20) DEFAULT NULL,
  `promo_id` bigint(20) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cart_product`
--

CREATE TABLE `cart_product` (
  `id` bigint(20) NOT NULL,
  `cart_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `config` text COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `id` bigint(20) NOT NULL,
  `aid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Alternative id for foreign systems',
  `client_group_id` bigint(20) DEFAULT NULL,
  `role` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'client' COMMENT 'client',
  `auth_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pass` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `salt` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT 'active' COMMENT 'active, suspended, canceled',
  `email_approved` tinyint(1) DEFAULT NULL,
  `tax_exempt` tinyint(1) DEFAULT 0,
  `type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `phone_cc` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company_vat` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `postcode` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `document_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `document_nr` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lang` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `api_token` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `referred_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `custom_1` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `custom_2` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `custom_3` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `custom_4` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `custom_5` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `custom_6` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `custom_7` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `custom_8` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `custom_9` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `custom_10` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `client_balance`
--

CREATE TABLE `client_balance` (
  `id` bigint(20) NOT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rel_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` decimal(18,2) DEFAULT 0.00,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `client_group`
--

CREATE TABLE `client_group` (
  `id` bigint(20) NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `client_order`
--

CREATE TABLE `client_order` (
  `id` bigint(20) NOT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `form_id` bigint(20) DEFAULT NULL,
  `promo_id` bigint(20) DEFAULT NULL,
  `promo_recurring` tinyint(1) DEFAULT NULL,
  `promo_used` bigint(20) DEFAULT NULL,
  `group_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `group_master` tinyint(1) DEFAULT 0,
  `invoice_option` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unpaid_invoice_id` bigint(20) DEFAULT NULL,
  `service_id` bigint(20) DEFAULT NULL,
  `service_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `period` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` bigint(20) DEFAULT 1,
  `unit` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` double(18,2) DEFAULT NULL,
  `discount` double(18,2) DEFAULT NULL COMMENT 'first invoice discount',
  `status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'suspend/cancel reason',
  `notes` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `config` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `referred_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `activated_at` datetime DEFAULT NULL,
  `suspended_at` datetime DEFAULT NULL,
  `unsuspended_at` datetime DEFAULT NULL,
  `canceled_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `client_order_meta`
--

CREATE TABLE `client_order_meta` (
  `id` bigint(20) NOT NULL,
  `client_order_id` bigint(20) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `client_order_status`
--

CREATE TABLE `client_order_status` (
  `id` bigint(20) NOT NULL,
  `client_order_id` bigint(20) DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `client_password_reset`
--

CREATE TABLE `client_password_reset` (
  `id` bigint(20) NOT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `hash` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `currency`
--

CREATE TABLE `currency` (
  `id` bigint(20) NOT NULL,
  `title` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT 0,
  `conversion_rate` decimal(13,6) DEFAULT 1.000000,
  `format` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price_format` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `email_template`
--

CREATE TABLE `email_template` (
  `id` bigint(20) NOT NULL,
  `action_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'general, domain, invoice, hosting, support, download, custom, license',
  `enabled` tinyint(1) DEFAULT 1,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vars` text COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `extension`
--

CREATE TABLE `extension` (
  `id` bigint(20) NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `version` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `manifest` text COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `extension_meta`
--

CREATE TABLE `extension_meta` (
  `id` bigint(20) NOT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `extension` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rel_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rel_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_key` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_value` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `form`
--

CREATE TABLE `form` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `style` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `form_field`
--

CREATE TABLE `form_field` (
  `id` bigint(20) NOT NULL,
  `form_id` bigint(20) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `label` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hide_label` tinyint(1) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `default_value` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `required` tinyint(1) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  `readonly` tinyint(1) DEFAULT NULL,
  `is_unique` tinyint(1) DEFAULT NULL,
  `prefix` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `suffix` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `options` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `show_initial` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `show_middle` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `show_prefix` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `show_suffix` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `text_size` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `forum`
--

CREATE TABLE `forum` (
  `id` bigint(20) NOT NULL,
  `category` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `forum_topic`
--

CREATE TABLE `forum_topic` (
  `id` bigint(20) NOT NULL,
  `forum_id` bigint(20) DEFAULT NULL,
  `title` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sticky` tinyint(1) DEFAULT 0,
  `views` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `forum_topic_message`
--

CREATE TABLE `forum_topic_message` (
  `id` bigint(20) NOT NULL,
  `forum_topic_id` bigint(20) DEFAULT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `message` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `points` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoice`
--

CREATE TABLE `invoice` (
  `id` bigint(20) NOT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `serie` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nr` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hash` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'To access via public link',
  `currency` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency_rate` decimal(13,6) DEFAULT NULL,
  `credit` double(18,2) DEFAULT NULL,
  `base_income` double(18,2) DEFAULT NULL COMMENT 'Income in default currency',
  `base_refund` double(18,2) DEFAULT NULL COMMENT 'Refund in default currency',
  `refund` double(18,2) DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `text_1` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `text_2` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'unpaid' COMMENT 'paid, unpaid',
  `seller_company` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seller_company_vat` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seller_company_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seller_address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seller_phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seller_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `buyer_first_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `buyer_last_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `buyer_company` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `buyer_company_vat` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `buyer_company_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `buyer_address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `buyer_city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `buyer_state` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `buyer_country` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `buyer_zip` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `buyer_phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `buyer_phone_cc` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `buyer_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gateway_id` int(11) DEFAULT NULL,
  `approved` tinyint(1) DEFAULT 0,
  `taxname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `taxrate` varchar(35) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `due_at` datetime DEFAULT NULL,
  `reminded_at` datetime DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoice_item`
--

CREATE TABLE `invoice_item` (
  `id` bigint(20) NOT NULL,
  `invoice_id` bigint(20) DEFAULT NULL,
  `type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rel_id` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `task` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `period` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` bigint(20) DEFAULT NULL,
  `unit` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` double(18,2) DEFAULT NULL,
  `charged` tinyint(1) DEFAULT 0,
  `taxed` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kb_article`
--

CREATE TABLE `kb_article` (
  `id` bigint(20) NOT NULL,
  `kb_article_category_id` bigint(20) DEFAULT NULL,
  `views` int(11) DEFAULT 0,
  `title` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT 'active' COMMENT 'active, draft',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kb_article_category`
--

CREATE TABLE `kb_article_category` (
  `id` bigint(20) NOT NULL,
  `title` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `mod_email_queue`
--

CREATE TABLE `mod_email_queue` (
  `id` int(11) NOT NULL,
  `recipient` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sender` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` int(11) DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `tries` int(11) NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `mod_massmailer`
--

CREATE TABLE `mod_massmailer` (
  `id` bigint(20) NOT NULL,
  `from_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `filter` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sent_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pay_gateway`
--

CREATE TABLE `pay_gateway` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gateway` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `accepted_currencies` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `enabled` tinyint(1) DEFAULT 1,
  `allow_single` tinyint(1) DEFAULT 1,
  `allow_recurrent` tinyint(1) DEFAULT 1,
  `test_mode` tinyint(1) DEFAULT 0,
  `config` text COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `post`
--

CREATE TABLE `post` (
  `id` bigint(20) NOT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT 'draft' COMMENT 'active, draft',
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `section` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `publish_at` datetime DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id` bigint(20) NOT NULL,
  `product_category_id` bigint(20) DEFAULT NULL,
  `product_payment_id` bigint(20) DEFAULT NULL,
  `form_id` bigint(20) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'product',
  `active` tinyint(1) DEFAULT 1,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'enabled' COMMENT 'enabled, disabled',
  `hidden` tinyint(1) DEFAULT 0,
  `is_addon` tinyint(1) DEFAULT 0,
  `setup` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'after_payment',
  `addons` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `allow_quantity_select` tinyint(1) DEFAULT 0,
  `stock_control` tinyint(1) DEFAULT 0,
  `quantity_in_stock` int(11) DEFAULT 0,
  `plugin` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `plugin_config` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `upgrades` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `priority` bigint(20) DEFAULT NULL,
  `config` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_category`
--

CREATE TABLE `product_category` (
  `id` bigint(20) NOT NULL,
  `title` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_payment`
--

CREATE TABLE `product_payment` (
  `id` bigint(20) NOT NULL,
  `type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'free, once, recurrent',
  `once_price` decimal(18,2) DEFAULT 0.00,
  `once_setup_price` decimal(18,2) DEFAULT 0.00,
  `w_price` decimal(18,2) DEFAULT 0.00,
  `m_price` decimal(18,2) DEFAULT 0.00,
  `q_price` decimal(18,2) DEFAULT 0.00,
  `b_price` decimal(18,2) DEFAULT 0.00,
  `a_price` decimal(18,2) DEFAULT 0.00,
  `bia_price` decimal(18,2) DEFAULT 0.00,
  `tria_price` decimal(18,2) DEFAULT 0.00,
  `w_setup_price` decimal(18,2) DEFAULT 0.00,
  `m_setup_price` decimal(18,2) DEFAULT 0.00,
  `q_setup_price` decimal(18,2) DEFAULT 0.00,
  `b_setup_price` decimal(18,2) DEFAULT 0.00,
  `a_setup_price` decimal(18,2) DEFAULT 0.00,
  `bia_setup_price` decimal(18,2) DEFAULT 0.00,
  `tria_setup_price` decimal(18,2) DEFAULT 0.00,
  `w_enabled` tinyint(1) DEFAULT 1,
  `m_enabled` tinyint(1) DEFAULT 1,
  `q_enabled` tinyint(1) DEFAULT 1,
  `b_enabled` tinyint(1) DEFAULT 1,
  `a_enabled` tinyint(1) DEFAULT 1,
  `bia_enabled` tinyint(1) DEFAULT 1,
  `tria_enabled` tinyint(1) DEFAULT 1
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `promo`
--

CREATE TABLE `promo` (
  `id` bigint(20) NOT NULL,
  `code` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'percentage' COMMENT 'absolute, percentage, trial',
  `value` decimal(18,2) DEFAULT NULL,
  `maxuses` int(11) DEFAULT 0,
  `used` int(11) DEFAULT 0,
  `freesetup` tinyint(1) DEFAULT 0,
  `once_per_client` tinyint(1) DEFAULT 0,
  `recurring` tinyint(1) DEFAULT 0,
  `active` tinyint(1) DEFAULT 0,
  `products` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `periods` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_groups` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `start_at` datetime DEFAULT NULL,
  `end_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `queue`
--

CREATE TABLE `queue` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `module` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `timeout` bigint(20) DEFAULT NULL,
  `iteration` int(10) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `queue_message`
--

CREATE TABLE `queue_message` (
  `id` bigint(20) NOT NULL,
  `queue_id` bigint(20) DEFAULT NULL,
  `handle` char(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `handler` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `body` longblob DEFAULT NULL,
  `hash` char(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `timeout` double(18,2) DEFAULT NULL,
  `log` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `execute_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `service_custom`
--

CREATE TABLE `service_custom` (
  `id` bigint(20) NOT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `plugin` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `plugin_config` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `f1` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `f2` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `f3` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `f4` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `f5` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `f6` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `f7` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `f8` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `f9` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `f10` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `config` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `service_domain`
--

CREATE TABLE `service_domain` (
  `id` bigint(20) NOT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `tld_registrar_id` bigint(20) DEFAULT NULL,
  `sld` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tld` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ns1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ns2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ns3` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ns4` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `period` int(11) DEFAULT NULL,
  `privacy` int(11) DEFAULT NULL,
  `locked` tinyint(1) DEFAULT 1,
  `transfer_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `action` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_company` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_first_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_last_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_address1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_address2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_state` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_postcode` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_country` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_phone_cc` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `details` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `synced_at` datetime DEFAULT NULL,
  `registered_at` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `service_downloadable`
--

CREATE TABLE `service_downloadable` (
  `id` bigint(20) NOT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `filename` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `downloads` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `service_hosting`
--

CREATE TABLE `service_hosting` (
  `id` bigint(20) NOT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `service_hosting_server_id` bigint(20) DEFAULT NULL,
  `service_hosting_hp_id` bigint(20) DEFAULT NULL,
  `sld` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tld` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pass` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reseller` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `service_hosting_hp`
--

CREATE TABLE `service_hosting_hp` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quota` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bandwidth` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `max_ftp` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `max_sql` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `max_pop` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `max_sub` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `max_park` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `max_addon` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `config` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `service_hosting_server`
--

CREATE TABLE `service_hosting_server` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hostname` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `assigned_ips` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `max_accounts` bigint(20) DEFAULT NULL,
  `ns1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ns2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ns3` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ns4` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `manager` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `username` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `accesshash` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `port` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `config` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `secure` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `service_license`
--

CREATE TABLE `service_license` (
  `id` bigint(20) NOT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `license_key` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `validate_ip` tinyint(1) DEFAULT 1,
  `validate_host` tinyint(1) DEFAULT 1,
  `validate_path` tinyint(1) DEFAULT 0,
  `validate_version` tinyint(1) DEFAULT 0,
  `ips` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hosts` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paths` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `versions` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `config` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `plugin` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `pinged_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `service_membership`
--

CREATE TABLE `service_membership` (
  `id` bigint(20) NOT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `config` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `service_solusvm`
--

CREATE TABLE `service_solusvm` (
  `id` bigint(20) NOT NULL,
  `cluster_id` bigint(20) DEFAULT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `vserverid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `virtid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nodeid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `node` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nodegroup` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hostname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rootpassword` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `plan` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `template` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ips` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hvmt` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `custommemory` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customdiskspace` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `custombandwidth` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customcpu` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customextraip` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `issuelicense` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mainipaddress` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `extraipaddress` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `consoleuser` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `consolepassword` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `config` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `session`
--

CREATE TABLE `session` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `modified_at` int(11) DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `setting`
--

CREATE TABLE `setting` (
  `id` bigint(20) NOT NULL,
  `param` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `public` tinyint(1) DEFAULT 0,
  `category` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hash` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `subscription`
--

CREATE TABLE `subscription` (
  `id` bigint(20) NOT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `pay_gateway_id` bigint(20) DEFAULT NULL,
  `sid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rel_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rel_id` bigint(20) DEFAULT NULL,
  `period` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` double(18,2) DEFAULT NULL,
  `currency` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `support_helpdesk`
--

CREATE TABLE `support_helpdesk` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `close_after` smallint(6) DEFAULT 24,
  `can_reopen` tinyint(1) DEFAULT 0,
  `signature` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `support_pr`
--

CREATE TABLE `support_pr` (
  `id` bigint(20) NOT NULL,
  `support_pr_category_id` bigint(20) DEFAULT NULL,
  `title` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `support_pr_category`
--

CREATE TABLE `support_pr_category` (
  `id` bigint(20) NOT NULL,
  `title` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `support_p_ticket`
--

CREATE TABLE `support_p_ticket` (
  `id` bigint(20) NOT NULL,
  `hash` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `author_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `author_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT 'open',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `support_p_ticket_message`
--

CREATE TABLE `support_p_ticket_message` (
  `id` bigint(20) NOT NULL,
  `support_p_ticket_id` bigint(20) DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL COMMENT 'Filled when message author is admin',
  `content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `support_ticket`
--

CREATE TABLE `support_ticket` (
  `id` bigint(20) NOT NULL,
  `support_helpdesk_id` bigint(20) DEFAULT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `priority` int(11) DEFAULT 100,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT 'open' COMMENT 'open, closed, on_hold',
  `rel_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rel_id` bigint(20) DEFAULT NULL,
  `rel_task` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rel_new_value` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rel_status` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `support_ticket_message`
--

CREATE TABLE `support_ticket_message` (
  `id` bigint(20) NOT NULL,
  `support_ticket_id` bigint(20) DEFAULT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attachment` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `support_ticket_note`
--

CREATE TABLE `support_ticket_note` (
  `id` bigint(20) NOT NULL,
  `support_ticket_id` bigint(20) DEFAULT NULL,
  `admin_id` bigint(20) DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tax`
--

CREATE TABLE `tax` (
  `id` bigint(20) NOT NULL,
  `level` bigint(20) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `taxrate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tld`
--

CREATE TABLE `tld` (
  `id` bigint(20) NOT NULL,
  `tld_registrar_id` bigint(20) DEFAULT NULL,
  `tld` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price_registration` decimal(18,2) DEFAULT 0.00,
  `price_renew` decimal(18,2) DEFAULT 0.00,
  `price_transfer` decimal(18,2) DEFAULT 0.00,
  `allow_register` tinyint(1) DEFAULT NULL,
  `allow_transfer` tinyint(1) DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,
  `min_years` tinyint(4) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tld_registrar`
--

CREATE TABLE `tld_registrar` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `registrar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `test_mode` tinyint(4) DEFAULT 0,
  `config` text COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `id` bigint(20) NOT NULL,
  `invoice_id` bigint(20) DEFAULT NULL,
  `gateway_id` int(11) DEFAULT NULL,
  `txn_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `txn_status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `s_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `s_period` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'received',
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `error` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `error_code` int(11) DEFAULT NULL,
  `validate_ipn` tinyint(1) DEFAULT 1,
  `ipn` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `output` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_admin_history`
--
ALTER TABLE `activity_admin_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_id_idx` (`admin_id`);

--
-- Indexes for table `activity_client_email`
--
ALTER TABLE `activity_client_email`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id_idx` (`client_id`);

--
-- Indexes for table `activity_client_history`
--
ALTER TABLE `activity_client_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id_idx` (`client_id`);

--
-- Indexes for table `activity_system`
--
ALTER TABLE `activity_system`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_id_idx` (`admin_id`),
  ADD KEY `client_id_idx` (`client_id`);

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`) USING HASH,
  ADD KEY `admin_group_id_idx` (`admin_group_id`);

--
-- Indexes for table `admin_group`
--
ALTER TABLE `admin_group`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `api_request`
--
ALTER TABLE `api_request`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `session_id_idx` (`session_id`),
  ADD KEY `currency_id_idx` (`currency_id`),
  ADD KEY `promo_id_idx` (`promo_id`);

--
-- Indexes for table `cart_product`
--
ALTER TABLE `cart_product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_id_idx` (`cart_id`),
  ADD KEY `product_id_idx` (`product_id`);

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`) USING HASH,
  ADD KEY `alternative_id_idx` (`aid`(250)),
  ADD KEY `client_group_id_idx` (`client_group_id`);

--
-- Indexes for table `client_balance`
--
ALTER TABLE `client_balance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id_idx` (`client_id`);

--
-- Indexes for table `client_group`
--
ALTER TABLE `client_group`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `client_order`
--
ALTER TABLE `client_order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id_idx` (`client_id`),
  ADD KEY `product_id_idx` (`product_id`),
  ADD KEY `form_id_idx` (`form_id`),
  ADD KEY `promo_id_idx` (`promo_id`);

--
-- Indexes for table `client_order_meta`
--
ALTER TABLE `client_order_meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_order_id_idx` (`client_order_id`);

--
-- Indexes for table `client_order_status`
--
ALTER TABLE `client_order_status`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_order_id_idx` (`client_order_id`);

--
-- Indexes for table `client_password_reset`
--
ALTER TABLE `client_password_reset`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id_idx` (`client_id`);

--
-- Indexes for table `currency`
--
ALTER TABLE `currency`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `email_template`
--
ALTER TABLE `email_template`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `action_code` (`action_code`) USING HASH;

--
-- Indexes for table `extension`
--
ALTER TABLE `extension`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `extension_meta`
--
ALTER TABLE `extension_meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id_idx` (`client_id`);

--
-- Indexes for table `form`
--
ALTER TABLE `form`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `form_field`
--
ALTER TABLE `form_field`
  ADD PRIMARY KEY (`id`),
  ADD KEY `form_id_idx` (`form_id`);

--
-- Indexes for table `forum`
--
ALTER TABLE `forum`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`) USING HASH;

--
-- Indexes for table `forum_topic`
--
ALTER TABLE `forum_topic`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`) USING HASH,
  ADD KEY `forum_id_idx` (`forum_id`);

--
-- Indexes for table `forum_topic_message`
--
ALTER TABLE `forum_topic_message`
  ADD PRIMARY KEY (`id`),
  ADD KEY `forum_topic_id_idx` (`forum_topic_id`),
  ADD KEY `client_id_idx` (`client_id`),
  ADD KEY `admin_id_idx` (`admin_id`);

--
-- Indexes for table `invoice`
--
ALTER TABLE `invoice`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `hash` (`hash`) USING HASH,
  ADD KEY `client_id_idx` (`client_id`);

--
-- Indexes for table `invoice_item`
--
ALTER TABLE `invoice_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoice_id_idx` (`invoice_id`);

--
-- Indexes for table `kb_article`
--
ALTER TABLE `kb_article`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`) USING HASH,
  ADD KEY `kb_article_category_id_idx` (`kb_article_category_id`);

--
-- Indexes for table `kb_article_category`
--
ALTER TABLE `kb_article_category`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`) USING HASH;

--
-- Indexes for table `mod_email_queue`
--
ALTER TABLE `mod_email_queue`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mod_massmailer`
--
ALTER TABLE `mod_massmailer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pay_gateway`
--
ALTER TABLE `pay_gateway`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`) USING HASH,
  ADD KEY `admin_id_idx` (`admin_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`) USING HASH,
  ADD KEY `product_type_idx` (`type`(250)),
  ADD KEY `product_category_id_idx` (`product_category_id`),
  ADD KEY `product_payment_id_idx` (`product_payment_id`),
  ADD KEY `form_id_idx` (`form_id`);

--
-- Indexes for table `product_category`
--
ALTER TABLE `product_category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product_payment`
--
ALTER TABLE `product_payment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `promo`
--
ALTER TABLE `promo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `start_index_idx` (`start_at`),
  ADD KEY `end_index_idx` (`end_at`),
  ADD KEY `active_index_idx` (`active`),
  ADD KEY `code_index_idx` (`code`);

--
-- Indexes for table `queue`
--
ALTER TABLE `queue`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `queue_message`
--
ALTER TABLE `queue_message`
  ADD PRIMARY KEY (`id`),
  ADD KEY `queue_id_idx` (`queue_id`);

--
-- Indexes for table `service_custom`
--
ALTER TABLE `service_custom`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id_idx` (`client_id`);

--
-- Indexes for table `service_domain`
--
ALTER TABLE `service_domain`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id_idx` (`client_id`),
  ADD KEY `tld_registrar_id_idx` (`tld_registrar_id`);

--
-- Indexes for table `service_downloadable`
--
ALTER TABLE `service_downloadable`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id_idx` (`client_id`);

--
-- Indexes for table `service_hosting`
--
ALTER TABLE `service_hosting`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id_idx` (`client_id`),
  ADD KEY `service_hosting_server_id_idx` (`service_hosting_server_id`),
  ADD KEY `service_hosting_hp_id_idx` (`service_hosting_hp_id`);

--
-- Indexes for table `service_hosting_hp`
--
ALTER TABLE `service_hosting_hp`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `service_hosting_server`
--
ALTER TABLE `service_hosting_server`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `service_license`
--
ALTER TABLE `service_license`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `license_key` (`license_key`) USING HASH,
  ADD KEY `client_id_idx` (`client_id`);

--
-- Indexes for table `service_membership`
--
ALTER TABLE `service_membership`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id_idx` (`client_id`);

--
-- Indexes for table `service_solusvm`
--
ALTER TABLE `service_solusvm`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id_idx` (`client_id`);

--
-- Indexes for table `session`
--
ALTER TABLE `session`
  ADD UNIQUE KEY `unique_id` (`id`);

--
-- Indexes for table `setting`
--
ALTER TABLE `setting`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `param` (`param`) USING HASH;

--
-- Indexes for table `subscription`
--
ALTER TABLE `subscription`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id_idx` (`client_id`),
  ADD KEY `pay_gateway_id_idx` (`pay_gateway_id`);

--
-- Indexes for table `support_helpdesk`
--
ALTER TABLE `support_helpdesk`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `support_pr`
--
ALTER TABLE `support_pr`
  ADD PRIMARY KEY (`id`),
  ADD KEY `support_pr_category_id_idx` (`support_pr_category_id`);

--
-- Indexes for table `support_pr_category`
--
ALTER TABLE `support_pr_category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `support_p_ticket`
--
ALTER TABLE `support_p_ticket`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `support_p_ticket_message`
--
ALTER TABLE `support_p_ticket_message`
  ADD PRIMARY KEY (`id`),
  ADD KEY `support_p_ticket_id_idx` (`support_p_ticket_id`),
  ADD KEY `admin_id_idx` (`admin_id`);
ALTER TABLE `support_p_ticket_message` ADD FULLTEXT KEY `content_idx` (`content`);

--
-- Indexes for table `support_ticket`
--
ALTER TABLE `support_ticket`
  ADD PRIMARY KEY (`id`),
  ADD KEY `support_helpdesk_id_idx` (`support_helpdesk_id`),
  ADD KEY `client_id_idx` (`client_id`);

--
-- Indexes for table `support_ticket_message`
--
ALTER TABLE `support_ticket_message`
  ADD PRIMARY KEY (`id`),
  ADD KEY `support_ticket_id_idx` (`support_ticket_id`),
  ADD KEY `client_id_idx` (`client_id`),
  ADD KEY `admin_id_idx` (`admin_id`);
ALTER TABLE `support_ticket_message` ADD FULLTEXT KEY `content_idx` (`content`);

--
-- Indexes for table `support_ticket_note`
--
ALTER TABLE `support_ticket_note`
  ADD PRIMARY KEY (`id`),
  ADD KEY `support_ticket_id_idx` (`support_ticket_id`),
  ADD KEY `admin_id_idx` (`admin_id`);

--
-- Indexes for table `tax`
--
ALTER TABLE `tax`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tld`
--
ALTER TABLE `tld`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tld` (`tld`),
  ADD KEY `tld_registrar_id_idx` (`tld_registrar_id`);

--
-- Indexes for table `tld_registrar`
--
ALTER TABLE `tld_registrar`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoice_id_idx` (`invoice_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_admin_history`
--
ALTER TABLE `activity_admin_history`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `activity_client_email`
--
ALTER TABLE `activity_client_email`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `activity_client_history`
--
ALTER TABLE `activity_client_history`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `activity_system`
--
ALTER TABLE `activity_system`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admin_group`
--
ALTER TABLE `admin_group`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `api_request`
--
ALTER TABLE `api_request`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_product`
--
ALTER TABLE `cart_product`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `client_balance`
--
ALTER TABLE `client_balance`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `client_group`
--
ALTER TABLE `client_group`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `client_order`
--
ALTER TABLE `client_order`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `client_order_meta`
--
ALTER TABLE `client_order_meta`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `client_order_status`
--
ALTER TABLE `client_order_status`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `client_password_reset`
--
ALTER TABLE `client_password_reset`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `currency`
--
ALTER TABLE `currency`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `email_template`
--
ALTER TABLE `email_template`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `extension`
--
ALTER TABLE `extension`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `extension_meta`
--
ALTER TABLE `extension_meta`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `form`
--
ALTER TABLE `form`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `form_field`
--
ALTER TABLE `form_field`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `forum`
--
ALTER TABLE `forum`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `forum_topic`
--
ALTER TABLE `forum_topic`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `forum_topic_message`
--
ALTER TABLE `forum_topic_message`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoice`
--
ALTER TABLE `invoice`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoice_item`
--
ALTER TABLE `invoice_item`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `kb_article`
--
ALTER TABLE `kb_article`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `kb_article_category`
--
ALTER TABLE `kb_article_category`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mod_email_queue`
--
ALTER TABLE `mod_email_queue`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mod_massmailer`
--
ALTER TABLE `mod_massmailer`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pay_gateway`
--
ALTER TABLE `pay_gateway`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `post`
--
ALTER TABLE `post`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_category`
--
ALTER TABLE `product_category`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_payment`
--
ALTER TABLE `product_payment`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `promo`
--
ALTER TABLE `promo`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `queue`
--
ALTER TABLE `queue`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `queue_message`
--
ALTER TABLE `queue_message`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `service_custom`
--
ALTER TABLE `service_custom`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `service_domain`
--
ALTER TABLE `service_domain`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `service_downloadable`
--
ALTER TABLE `service_downloadable`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `service_hosting`
--
ALTER TABLE `service_hosting`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `service_hosting_hp`
--
ALTER TABLE `service_hosting_hp`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `service_hosting_server`
--
ALTER TABLE `service_hosting_server`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `service_license`
--
ALTER TABLE `service_license`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `service_membership`
--
ALTER TABLE `service_membership`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `service_solusvm`
--
ALTER TABLE `service_solusvm`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `setting`
--
ALTER TABLE `setting`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `subscription`
--
ALTER TABLE `subscription`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `support_helpdesk`
--
ALTER TABLE `support_helpdesk`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `support_pr`
--
ALTER TABLE `support_pr`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `support_pr_category`
--
ALTER TABLE `support_pr_category`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `support_p_ticket`
--
ALTER TABLE `support_p_ticket`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `support_p_ticket_message`
--
ALTER TABLE `support_p_ticket_message`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `support_ticket`
--
ALTER TABLE `support_ticket`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `support_ticket_message`
--
ALTER TABLE `support_ticket_message`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `support_ticket_note`
--
ALTER TABLE `support_ticket_note`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tax`
--
ALTER TABLE `tax`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tld`
--
ALTER TABLE `tld`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tld_registrar`
--
ALTER TABLE `tld_registrar`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

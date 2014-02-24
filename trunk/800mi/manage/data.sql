/*
SQLyog 企业版 - MySQL GUI v8.14 
MySQL - 5.1.33-community-log : Database - bm_manage
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`bm_manage` /*!40100 DEFAULT CHARACTER SET utf8 */;

/*Table structure for table `bm_account` */

DROP TABLE IF EXISTS `bm_account`;

CREATE TABLE `bm_account` (
  `account_id` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(64) NOT NULL,
  `account_pasword` varchar(32) NOT NULL,
  `account_name` varchar(256) NOT NULL COMMENT '升级根骨失败次数',
  `account_type` smallint(6) NOT NULL COMMENT '1普通用户\n            2供货商\n            4管理员\n            ',
  `account_money` int(11) NOT NULL,
  `account_level` smallint(6) NOT NULL,
  `account_state` smallint(6) NOT NULL COMMENT '开启,锁定,申请',
  `add_time` int(11) NOT NULL,
  `account_remark` varchar(800) DEFAULT NULL,
  PRIMARY KEY (`account_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Data for the table `bm_account` */

insert  into `bm_account`(`account_id`,`account`,`account_pasword`,`account_name`,`account_type`,`account_money`,`account_level`,`account_state`,`add_time`,`account_remark`) values (1,'liaoxb','dc483e80a7a0bd9ef71d8cf973673924','廖小波',1,0,1,1,1,'ycchen');
insert  into `bm_account`(`account_id`,`account`,`account_pasword`,`account_name`,`account_type`,`account_money`,`account_level`,`account_state`,`add_time`,`account_remark`) values (2,'stest','1f2de15d680024fca36c47e16f5c95d2','setset',0,0,0,99,1388655011,'set');
insert  into `bm_account`(`account_id`,`account`,`account_pasword`,`account_name`,`account_type`,`account_money`,`account_level`,`account_state`,`add_time`,`account_remark`) values (3,'test','1f2de15d680024fca36c47e16f5c95d2','ss',2,0,1,99,1388655324,'set');
insert  into `bm_account`(`account_id`,`account`,`account_pasword`,`account_name`,`account_type`,`account_money`,`account_level`,`account_state`,`add_time`,`account_remark`) values (4,'test','1f2de15d680024fca36c47e16f5c95d2','sees',2,0,1,0,1388655754,'set');
insert  into `bm_account`(`account_id`,`account`,`account_pasword`,`account_name`,`account_type`,`account_money`,`account_level`,`account_state`,`add_time`,`account_remark`) values (5,'12w','1f2de15d680024fca36c47e16f5c95d2','23',2,0,1,99,1388656191,'23');

/*Table structure for table `bm_account_group` */

DROP TABLE IF EXISTS `bm_account_group`;

CREATE TABLE `bm_account_group` (
  `group_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  PRIMARY KEY (`group_id`,`account_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_account_group` */

insert  into `bm_account_group`(`group_id`,`account_id`) values (1,1);

/*Table structure for table `bm_account_module` */

DROP TABLE IF EXISTS `bm_account_module`;

CREATE TABLE `bm_account_module` (
  `module_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  PRIMARY KEY (`module_id`,`account_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_account_module` */

insert  into `bm_account_module`(`module_id`,`account_id`) values (1,1);
insert  into `bm_account_module`(`module_id`,`account_id`) values (11,1);
insert  into `bm_account_module`(`module_id`,`account_id`) values (13,1);

/*Table structure for table `bm_event_log` */

DROP TABLE IF EXISTS `bm_event_log`;

CREATE TABLE `bm_event_log` (
  `event_log_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_id` varchar(64) DEFAULT NULL,
  `event_type` smallint(6) NOT NULL,
  `operate_ip` varchar(32) NOT NULL,
  `event_desc` varchar(2048) NOT NULL,
  `add_time` datetime NOT NULL,
  PRIMARY KEY (`event_log_id`)
) ENGINE=MyISAM AUTO_INCREMENT=142 DEFAULT CHARSET=utf8;

/*Data for the table `bm_event_log` */

insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (1,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2013-12-26 11:37:58');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (2,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2013-12-26 11:38:38');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (3,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2013-12-26 11:41:00');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (4,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 11:05:29');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (5,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 11:06:54');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (6,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 11:18:44');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (7,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 11:30:52');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (8,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 11:31:03');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (9,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 11:31:09');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (10,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 14:58:04');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (11,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 14:58:16');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (12,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 14:58:38');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (13,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:01:24');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (14,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:02:28');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (15,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:03:29');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (16,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:04:31');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (17,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:05:05');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (18,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:05:20');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (19,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:05:31');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (20,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:05:48');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (21,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:06:05');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (22,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:06:33');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (23,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:06:47');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (24,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:07:00');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (25,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:07:03');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (26,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:07:06');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (27,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:07:14');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (28,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:07:36');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (29,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:07:43');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (30,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:08:14');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (31,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:08:30');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (32,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:08:38');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (33,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:16:31');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (34,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:17:30');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (35,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:17:43');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (36,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:17:44');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (37,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:17:46');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (38,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:17:50');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (39,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:18:27');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (40,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:18:49');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (41,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:18:50');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (42,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:18:53');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (43,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:19:02');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (44,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:19:05');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (45,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:20:57');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (46,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:21:01');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (47,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:21:04');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (48,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:21:14');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (49,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:21:33');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (50,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:21:45');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (51,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:21:58');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (52,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:22:26');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (53,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:23:06');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (54,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:34:45');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (55,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:35:43');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (56,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:38:56');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (57,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:39:00');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (58,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 15:54:40');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (59,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 16:04:55');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (60,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 16:18:09');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (61,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 16:18:32');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (62,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 16:18:35');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (63,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 16:57:05');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (64,'1',1,'127.0.0.1','廖小波操作：新增分组：管理员','2013-12-30 16:58:12');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (65,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 17:04:51');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (66,'1',1,'127.0.0.1','廖小波操作：修改分组ID：1','2013-12-30 17:06:43');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (67,'1',1,'127.0.0.1','廖小波操作：修改分组ID：1','2013-12-30 17:06:52');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (68,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 17:11:33');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (69,'1',1,'127.0.0.1','廖小波操作：更新分组模块权限ID：1，新增：(1,1),(1,11),(1,12),(1,13),删除：','2013-12-30 17:32:23');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (70,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 17:39:44');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (71,'1',1,'127.0.0.1','廖小波操作：更新分组模块权限ID：1，新增：,删除：12','2013-12-30 17:55:52');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (72,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 17:56:29');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (73,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-31 09:16:49');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (74,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-31 09:52:02');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (75,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-31 10:01:30');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (76,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-31 10:01:34');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (77,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-31 10:04:05');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (78,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-31 13:03:02');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (79,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-31 13:03:56');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (80,'1',1,'192.168.3.14','廖小波操作：账号登陆：liaoxb','2013-12-31 13:21:53');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (81,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-31 15:24:09');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (82,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-31 15:42:16');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (83,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-31 15:48:54');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (84,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2014-01-02 10:37:31');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (85,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2014-01-02 10:58:48');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (86,'1',1,'192.168.3.105','廖小波操作：更新分组模块权限ID：1，新增：(1,12),删除：','2014-01-02 10:59:20');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (87,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2014-01-02 11:50:16');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (88,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2014-01-02 14:24:49');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (89,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2014-01-02 16:03:06');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (90,'1',1,'192.168.3.105','廖小波操作：更新模块权限ID：1，新增：,删除：13','2014-01-02 16:11:44');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (91,'1',1,'192.168.3.105','廖小波操作：更新模块权限ID：1，新增：(1,13),删除：','2014-01-02 16:11:50');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (92,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2014-01-02 16:18:11');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (93,'1',1,'192.168.3.105','廖小波操作：更新账号分组ID：1，新增：(1,1),删除：','2014-01-02 16:18:33');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (94,'1',1,'192.168.3.105','廖小波操作：更新模块权限ID：1，新增：,删除：1,11,12,13','2014-01-02 16:18:59');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (95,'1',1,'192.168.3.105','廖小波操作：更新模块权限ID：1，新增：,删除：1,11,12,13','2014-01-02 16:19:08');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (96,'1',1,'192.168.3.105','廖小波操作：更新模块权限ID：1，新增：,删除：12','2014-01-02 16:19:15');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (97,'1',1,'192.168.3.105','廖小波操作：更新账号分组ID：1，新增：,删除：1','2014-01-02 16:19:30');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (98,'1',1,'192.168.3.105','廖小波操作：更新模块权限ID：1，新增：(1,1),(1,11),(1,12),(1,13),删除：','2014-01-02 16:19:40');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (99,'1',1,'192.168.3.105','廖小波操作：更新模块权限ID：1，新增：,删除：12','2014-01-02 16:19:50');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (100,'1',1,'192.168.3.105','廖小波操作：更新账号分组ID：1，新增：(1,1),删除：','2014-01-02 16:19:55');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (101,'1',1,'192.168.3.105','廖小波操作：新增账号：test001','2014-01-02 17:05:58');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (102,'1',1,'192.168.3.105','廖小波操作：新增账号：test001','2014-01-02 17:06:29');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (103,'1',1,'192.168.3.105','廖小波操作：新增账号：test001','2014-01-02 17:06:45');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (104,'1',1,'192.168.3.105','廖小波操作：新增账号：test001','2014-01-02 17:09:05');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (105,'1',1,'192.168.3.105','廖小波操作：新增账号：test','2014-01-02 17:20:42');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (106,'1',1,'192.168.3.105','廖小波操作：新增账号：test','2014-01-02 17:23:36');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (107,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2014-01-02 17:24:08');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (108,'1',1,'192.168.3.105','廖小波操作：新增账号：test','2014-01-02 17:24:16');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (109,'1',1,'192.168.3.105','廖小波操作：新增账号：1212','2014-01-02 17:28:19');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (110,'1',1,'192.168.3.105','廖小波操作：新增账号：stest','2014-01-02 17:28:34');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (111,'1',1,'192.168.3.105','廖小波操作：新增账号：stest','2014-01-02 17:29:08');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (112,'1',1,'192.168.3.105','廖小波操作：新增账号：stest','2014-01-02 17:30:11');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (113,'1',1,'192.168.3.105','廖小波操作：新增账号：stest','2014-01-02 17:30:34');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (114,'1',1,'192.168.3.105','廖小波操作：新增账号：stest','2014-01-02 17:30:45');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (115,'1',1,'192.168.3.105','廖小波操作：新增账号：stest','2014-01-02 17:32:14');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (116,'1',1,'192.168.3.105','廖小波操作：新增账号：tste','2014-01-02 17:33:27');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (117,'1',1,'192.168.3.105','廖小波操作：修改账号信息ID：2','2014-01-02 17:34:02');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (118,'1',1,'192.168.3.105','廖小波操作：新增账号：test','2014-01-02 17:35:24');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (119,'1',1,'192.168.3.105','廖小波操作：修改账号信息ID：2','2014-01-02 17:37:41');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (120,'1',1,'192.168.3.105','廖小波操作：修改账号信息ID：3','2014-01-02 17:37:51');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (121,'1',1,'192.168.3.105','廖小波操作：新增账号：test','2014-01-02 17:42:34');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (122,'1',1,'192.168.3.105','廖小波操作：新增账号：123','2014-01-02 17:43:42');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (123,'1',1,'192.168.3.105','廖小波操作：新增账号：123','2014-01-02 17:43:56');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (124,'1',1,'192.168.3.105','廖小波操作：新增账号：123','2014-01-02 17:44:27');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (125,'1',1,'192.168.3.105','廖小波操作：新增账号：123','2014-01-02 17:45:47');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (126,'1',1,'192.168.3.105','廖小波操作：新增账号：123','2014-01-02 17:46:42');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (127,'1',1,'192.168.3.105','廖小波操作：新增账号：123','2014-01-02 17:48:24');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (128,'1',1,'192.168.3.105','廖小波操作：新增账号：liaoxb','2014-01-02 17:49:05');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (129,'1',1,'192.168.3.105','廖小波操作：新增账号：liaoxb','2014-01-02 17:49:46');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (130,'1',1,'192.168.3.105','廖小波操作：新增账号：12w','2014-01-02 17:49:51');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (131,'1',1,'192.168.3.105','廖小波操作：新增账号：12w','2014-01-02 17:50:20');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (132,'1',1,'192.168.3.105','廖小波操作：新增账号：12w','2014-01-02 17:50:44');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (133,'1',1,'192.168.3.105','廖小波操作：新增账号：12w','2014-01-02 17:50:56');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (134,'1',1,'192.168.3.105','廖小波操作：新增账号：12w','2014-01-02 17:52:00');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (135,'1',1,'192.168.3.105','廖小波操作：新增账号：12w','2014-01-02 17:52:22');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (136,'1',1,'192.168.3.105','廖小波操作：修改账号信息ID：5','2014-01-02 17:58:12');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (137,'1',1,'192.168.3.105','廖小波操作：修改账号信息ID：5','2014-01-02 18:00:26');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (138,'1',1,'192.168.3.105','廖小波操作：修改账号信息ID：5','2014-01-02 18:00:35');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (139,'1',1,'192.168.3.105','廖小波操作：修改账号信息ID：5','2014-01-02 18:00:49');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (140,'1',1,'192.168.3.105','廖小波操作：修改账号信息ID：5','2014-01-02 18:14:42');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (141,'1',1,'192.168.3.105','廖小波操作：修改账号信息ID：5','2014-01-02 18:14:53');

/*Table structure for table `bm_favorites` */

DROP TABLE IF EXISTS `bm_favorites`;

CREATE TABLE `bm_favorites` (
  `account_id` int(11) NOT NULL,
  `goods_id` int(11) NOT NULL,
  PRIMARY KEY (`account_id`,`goods_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_favorites` */

/*Table structure for table `bm_goods` */

DROP TABLE IF EXISTS `bm_goods`;

CREATE TABLE `bm_goods` (
  `goods_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `type1_id` int(11) NOT NULL,
  `brand_id` int(11) NOT NULL,
  `type3_id` int(11) DEFAULT NULL,
  `goods_barcode` bigint(20) NOT NULL,
  `goods_name` varchar(246) NOT NULL,
  `goods_weight` int(11) NOT NULL,
  `goods_active_stime` int(11) NOT NULL,
  `goods_active_etime` int(11) NOT NULL,
  `goods_pic_url` varchar(246) NOT NULL,
  `goods_state` smallint(6) NOT NULL,
  `goods_number` int(11) NOT NULL,
  `goods_price` int(11) NOT NULL,
  `goods_active_price` int(11) NOT NULL,
  `goods_remark` varchar(128) NOT NULL,
  PRIMARY KEY (`goods_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_goods` */

/*Table structure for table `bm_goods_brand` */

DROP TABLE IF EXISTS `bm_goods_brand`;

CREATE TABLE `bm_goods_brand` (
  `brand_id` int(11) NOT NULL,
  `brand_name` varchar(64) NOT NULL,
  `brand_order` int(11) NOT NULL,
  `brand_state` smallint(6) NOT NULL,
  PRIMARY KEY (`brand_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_goods_brand` */

/*Table structure for table `bm_goods_type1` */

DROP TABLE IF EXISTS `bm_goods_type1`;

CREATE TABLE `bm_goods_type1` (
  `type1_id` int(11) NOT NULL,
  `type1_name` varchar(64) NOT NULL,
  `type1_order` int(11) NOT NULL,
  `type1_state` smallint(6) NOT NULL,
  PRIMARY KEY (`type1_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_goods_type1` */

/*Table structure for table `bm_goods_type2` */

DROP TABLE IF EXISTS `bm_goods_type2`;

CREATE TABLE `bm_goods_type2` (
  `type2_id` int(11) NOT NULL,
  `type1_id` int(11) NOT NULL,
  `type2_name` varchar(64) NOT NULL,
  `type2_order` int(11) NOT NULL,
  `type2_state` smallint(6) NOT NULL,
  PRIMARY KEY (`type2_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_goods_type2` */

/*Table structure for table `bm_goods_type3` */

DROP TABLE IF EXISTS `bm_goods_type3`;

CREATE TABLE `bm_goods_type3` (
  `type3_id` int(11) NOT NULL,
  `type2_id` int(11) NOT NULL,
  `type3_name` varchar(64) NOT NULL,
  `type3_order` int(11) NOT NULL,
  `type3_state` smallint(6) NOT NULL,
  PRIMARY KEY (`type3_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_goods_type3` */

/*Table structure for table `bm_group` */

DROP TABLE IF EXISTS `bm_group`;

CREATE TABLE `bm_group` (
  `group_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(64) NOT NULL,
  `group_remark` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`group_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `bm_group` */

insert  into `bm_group`(`group_id`,`group_name`,`group_remark`) values (1,'管理员','管理员系统后台管理人员');

/*Table structure for table `bm_group_module` */

DROP TABLE IF EXISTS `bm_group_module`;

CREATE TABLE `bm_group_module` (
  `group_id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL,
  PRIMARY KEY (`group_id`,`module_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_group_module` */

insert  into `bm_group_module`(`group_id`,`module_id`) values (1,1);
insert  into `bm_group_module`(`group_id`,`module_id`) values (1,11);
insert  into `bm_group_module`(`group_id`,`module_id`) values (1,12);
insert  into `bm_group_module`(`group_id`,`module_id`) values (1,13);

/*Table structure for table `bm_module` */

DROP TABLE IF EXISTS `bm_module`;

CREATE TABLE `bm_module` (
  `module_id` int(11) NOT NULL AUTO_INCREMENT,
  `module_name` varchar(32) NOT NULL,
  `fmodule_id` int(11) NOT NULL,
  `module_level` int(11) NOT NULL,
  `module_url` varchar(256) NOT NULL,
  `fmodule_url` varchar(256) NOT NULL,
  `module_pri` smallint(6) NOT NULL,
  `module_state` smallint(6) NOT NULL,
  `module_remark` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`module_id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

/*Data for the table `bm_module` */

insert  into `bm_module`(`module_id`,`module_name`,`fmodule_id`,`module_level`,`module_url`,`fmodule_url`,`module_pri`,`module_state`,`module_remark`) values (1,'基础数据维护',0,1,'/view/sszt/OnlineLog.php','',1,3,'');
insert  into `bm_module`(`module_id`,`module_name`,`fmodule_id`,`module_level`,`module_url`,`fmodule_url`,`module_pri`,`module_state`,`module_remark`) values (11,'功能模块维护',1,1,'/view/BaseData/ModuleManage.php','',1,1,'功能模块维护');
insert  into `bm_module`(`module_id`,`module_name`,`fmodule_id`,`module_level`,`module_url`,`fmodule_url`,`module_pri`,`module_state`,`module_remark`) values (12,'分组管理',1,1,'/view/BaseData/GroupManage.php','',2,1,'分组管理');
insert  into `bm_module`(`module_id`,`module_name`,`fmodule_id`,`module_level`,`module_url`,`fmodule_url`,`module_pri`,`module_state`,`module_remark`) values (13,'账号管理',1,1,'/view/BaseData/AccountManage.php','',3,1,'账号管理');

/*Table structure for table `bm_purchase_info` */

DROP TABLE IF EXISTS `bm_purchase_info`;

CREATE TABLE `bm_purchase_info` (
  `shopping_cart_id` bigint(20) NOT NULL,
  `purchase_id` int(11) NOT NULL,
  `goods_id` int(11) NOT NULL,
  `goods_num` int(11) NOT NULL,
  `purchase_goods_price` int(11) NOT NULL,
  `purchase_state` smallint(6) NOT NULL COMMENT '正常\n            缺货\n            退货\n            ',
  PRIMARY KEY (`shopping_cart_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_purchase_info` */

/*Table structure for table `bm_purchase_list` */

DROP TABLE IF EXISTS `bm_purchase_list`;

CREATE TABLE `bm_purchase_list` (
  `purchase_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `shop_id` int(11) NOT NULL,
  `add_time` int(11) NOT NULL,
  `purchase_state` smallint(6) NOT NULL COMMENT '提交，发货，收货，退货，关闭',
  `return_time` int(11) NOT NULL,
  `purchase_price` int(11) NOT NULL,
  `purchase_remak` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`purchase_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_purchase_list` */

/*Table structure for table `bm_return_info` */

DROP TABLE IF EXISTS `bm_return_info`;

CREATE TABLE `bm_return_info` (
  `shopping_cart_id` bigint(20) NOT NULL,
  `purchase_id` int(11) NOT NULL,
  `goods_id` int(11) NOT NULL,
  `return_goods_num` int(11) NOT NULL,
  `return_goods_price` int(11) NOT NULL,
  `return_state` smallint(6) NOT NULL COMMENT '正常\n            缺货\n            退货\n            ',
  PRIMARY KEY (`shopping_cart_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_return_info` */

/*Table structure for table `bm_return_list` */

DROP TABLE IF EXISTS `bm_return_list`;

CREATE TABLE `bm_return_list` (
  `purchase_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `shop_id` int(11) NOT NULL,
  `return_price` int(11) NOT NULL,
  `return_state` smallint(6) NOT NULL COMMENT '提交，发货，收货，退货，关闭',
  `return_time` int(11) NOT NULL,
  `return_remak` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`purchase_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_return_list` */

/*Table structure for table `bm_shop_point_supplier` */

DROP TABLE IF EXISTS `bm_shop_point_supplier`;

CREATE TABLE `bm_shop_point_supplier` (
  `account_id` int(11) NOT NULL,
  `supplier_account_id` int(11) NOT NULL,
  PRIMARY KEY (`account_id`,`supplier_account_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_shop_point_supplier` */

/*Table structure for table `bm_shopping_cart` */

DROP TABLE IF EXISTS `bm_shopping_cart`;

CREATE TABLE `bm_shopping_cart` (
  `shopping_cart_id` bigint(20) NOT NULL,
  `account_id` int(11) NOT NULL,
  `goods_id` int(11) NOT NULL,
  `goods_num` int(11) NOT NULL,
  `add_time` int(11) NOT NULL,
  PRIMARY KEY (`shopping_cart_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_shopping_cart` */

/*Table structure for table `bm_store_info` */

DROP TABLE IF EXISTS `bm_store_info`;

CREATE TABLE `bm_store_info` (
  `shop_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `shop_name` varchar(200) NOT NULL,
  `shop_province` varchar(16) NOT NULL,
  `shop_city` varchar(16) NOT NULL,
  `shop_district` varchar(16) NOT NULL,
  `shop_addr` varchar(200) NOT NULL,
  `shop_contacts` varchar(64) NOT NULL,
  `shop_phone` varchar(50) NOT NULL,
  `shop_state` smallint(6) NOT NULL COMMENT '营业中\n            关闭',
  PRIMARY KEY (`shop_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_store_info` */

/*Table structure for table `bm_supplier` */

DROP TABLE IF EXISTS `bm_supplier`;

CREATE TABLE `bm_supplier` (
  `account_id` int(11) NOT NULL,
  `supplier_name` varchar(200) NOT NULL,
  `supplier_province` varchar(16) NOT NULL,
  `supplier_city` varchar(16) NOT NULL,
  `supplier_district` varchar(16) NOT NULL,
  `supplier_addr` varchar(200) NOT NULL,
  `supplier_person` varchar(50) NOT NULL,
  `supplier_type` int(11) NOT NULL,
  `supplier_level` int(11) NOT NULL,
  `supplier_phone` int(11) NOT NULL,
  `supplier_remark` varchar(800) DEFAULT NULL,
  PRIMARY KEY (`account_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_supplier` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

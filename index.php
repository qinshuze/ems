<?php
require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/functions.php';

// 加载.env配置
load_env();

session_start();
define("PE_VERSION",'9.0');
define("PEPATH",dirname(__FILE__));
require PEPATH."/lib/init.cls.php";
$ginkgo = new \PHPEMS\ginkgo;
$ginkgo->run();
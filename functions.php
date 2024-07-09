<?php

/**
 * 装载.env文件中的配置到环境变量
 * @return void
 */
function load_env()
{
    $dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
    $dotenv->load();

    foreach ($_ENV as $k => $v) {
        putenv("$k=$v");
    }
}

/**
 * 获取环境变量
 * @param string $name
 * @param string $defaultValue
 * @return string
 */
function env(string $name, string $defaultValue = ""): string
{
    return $_ENV[$name] ?? $defaultValue;
}
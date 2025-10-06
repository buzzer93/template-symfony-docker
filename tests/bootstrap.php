<?php

use Symfony\Component\Dotenv\Dotenv;

require dirname(__DIR__).'/vendor/autoload.php';

// Avec Symfony 7.3, Dotenv::bootEnv existe toujours, plus besoin de garde
(new Dotenv())->bootEnv(dirname(__DIR__).'/.env');

// Protection si APP_DEBUG n'est pas défini (CLI, CI minimal, etc.)
if (!empty($_SERVER['APP_DEBUG'])) {
    umask(0000);
}

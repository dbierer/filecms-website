<?php
try {
    $config = require __DIR__ . '/../bootstrap.php';
    // init vars
    $body = '';
    $uri  = $_POST['uri'] ?? $_SERVER['REQUEST_URI'] ?? '';
    $uri  = parse_url($uri,  PHP_URL_PATH);
    $uri  = (strlen($uri) <= 1) ? '/home' : $uri;
    // pre-processing logic
    include SRC_DIR . '/processing.php';
    // routes w/ forms need to do an include
    $html_dir = $config['HTML_DIR'] ?? HTML_DIR;
    header('Content-Type: text/html');
    header('Content-Encoding: compress');
    // NOTE: added $html->notFound === TRUE if requested URL is not found
    //       you might want to add an if () statement and redirect if appropriate
    $html = new \FileCMS\Common\View\Html($config, $uri, $html_dir);
    echo $html->render();
} catch (Throwable $t) {
    error_log($t->getFile() . ':' . $t->getLine() . "\n" . $t->getTraceAsString());
    $msg = $t->getMessage();
    $layout = file_get_contents(__DIR__ . '/../templates/layout/layout.html');
    $error  = file_get_contents(__DIR__ . '/../templates/site/error.html');
    $error  = str_replace('%%ERROR%%', $msg, $error);
    echo str_replace('%%CONTENTS%%', $error, $layout);
}

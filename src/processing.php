<?php
// add pre-processing logic based on URL here:
use FileCMS\Common\View\Html;
use FileCMS\Common\Stats\Clicks;
use FileCMS\Common\Security\Profile;
use FileCMS\Common\Generic\Messages;
$click_fn  = $config['CLICK_CSV'] ?? BASE_DIR . '/logs/clicks.csv';
//Clicks::add($uri, $click_fn);
$super_url = $config['SUPER']['super_url'] ?? '/super';
$super_dir = $config['SUPER']['super_dir'] ?? BASE_DIR . '/templates/super';
if (strpos($uri, $super_url) === 0) {
    $body = '';
    $cards = FALSE;
    switch (TRUE) {
        case ($uri === $super_url . '/login') :
            header('Content-Type: text/html');
            header('Content-Encoding: compress');
            $html = new Html($config, $uri, $super_dir);
            echo $html->render();
            exit;
        case ($uri === $super_url . '/logout') :
        case ($uri === $super_url . '/quick_upload') :
        case ($uri === $super_url . '/choose') :
        case ($uri === $super_url . '/edit')   :
        case ($uri === $super_url . '/import') :
        case ($uri === $super_url . '/transform') :
            // check to see if authenticated
            if (Profile::verify() === FALSE) {
                Profile::logout();
                (Messages::getInstance())->addMessage(Messages::ERROR_AUTH);
                header('Location: /');
                exit;
            }
            header('Content-Type: text/html');
            header('Content-Encoding: compress');
            $html = new Html($config, $uri, $super_dir);
            echo $html->render($body, $cards);
            exit;
        case ($uri === $super_url . '/upload') :
            require SRC_DIR . '/upload.php';
            exit;
        case ($uri === $super_url . '/browse') :
            require SRC_DIR . '/browse.php';
            exit;
        default :
            // fall through
    }
    $uri = '/home';
}

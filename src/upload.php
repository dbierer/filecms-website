<?php
use FileCMS\Common\File\Upload;
use FileCMS\Common\Security\Profile;
use FileCMS\Common\Generic\Messages;
// process contact post (if any)
// $OBJ == calling instance (usually from /public/index.php)
if (!empty($OBJ)) {
    $uri    = $OBJ->uri;
    $config = $OBJ->config;
}
// check to see if authenticated
$upload = new Upload($config);
$auth_failed = false;
if (Profile::verify() === FALSE) {
    Profile::logout();
    (Messages::getInstance())->addMessage(Profile::PROFILE_AUTH_UNABLE);
    $upload->errors[] = Profile::PROFILE_AUTH_UNABLE;
    $result = $upload->getErrorResponse();
    $auth_failed = true;
} else {
    // Check token
    $token = $_SESSION['token'] ?? 'xxx';
    $hash  = base64_decode($_GET['token'] ?? 'yyy');
    if (!password_verify($token, $hash)) {
        header('Location: /');
        exit;
    }
    // TinyMCE's built-in image upload handler posts the file under the
    // field name "file" (not Upload::UPLOAD_FIELD_NAME, which is "upload"
    // and is used by the separate quick_upload.phtml form)
    // see: https://www.tiny.cloud/docs/tinymce/latest/upload-images/
    $result = $upload->handle('file');
}
// reshape the FileCMS\Common\File\Upload response into what TinyMCE's
// built-in image upload handler expects: {"location": url} on success,
// a non-200 status + {"error": message} on failure
// see: https://www.tiny.cloud/docs/tinymce/latest/upload-images/
if (empty($result['uploaded'])) {
    http_response_code($auth_failed ? 403 : 400);
    $response = ['error' => $result['error'] ?? Upload::UPLOAD_ERROR_UPLOAD];
} else {
    $response = ['location' => $result['url']];
}
header('Content-type: application/json');
echo json_encode($response);

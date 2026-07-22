<?php
// Copies vendor/tinymce/tinymce assets into public/tinymce.
// Run automatically by composer's post-install-cmd / post-update-cmd hooks
// (see composer.json) so `composer create-project` and `composer install`
// both leave public/tinymce ready to serve, with no manual copy step.

$src = __DIR__ . '/../vendor/tinymce/tinymce';
$dst = __DIR__ . '/../public/tinymce';
if (!is_dir($src)) {
    fwrite(STDERR, "copy-tinymce: source directory not found at $src, skipping.\n");
    exit(0);
}
if (!is_dir($dst)) mkdir($dst, 0755, true);
$iterator = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator($src, FilesystemIterator::SKIP_DOTS),
    RecursiveIteratorIterator::SELF_FIRST);
foreach ($iterator as $item) {
    $dstPath = $dst . DIRECTORY_SEPARATOR . $iterator->getSubPathName();
    if ($item->isDir()) {
        if (!is_dir($dstPath)) {
            mkdir($dstPath, 0755, true);
        }
    } else {
        copy($item->getPathname(), $dstPath);
    }
}
echo "Copied TinyMCE assets into public/tinymce\n";

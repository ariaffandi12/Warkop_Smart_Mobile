<?php
echo "Current directory: " . __DIR__ . "\n";
$upload_path = realpath(__DIR__ . "/../uploads");
echo "Upload path: " . $upload_path . "\n";
echo "Files in uploads/attendance/masuk:\n";
$masuk = __DIR__ . "/../uploads/attendance/masuk/";
if (is_dir($masuk)) {
    print_r(scandir($masuk));
} else {
    echo "Directory not found: $masuk\n";
}
echo "Files in uploads/attendance/pulang:\n";
$pulang = __DIR__ . "/../uploads/attendance/pulang/";
if (is_dir($pulang)) {
    print_r(scandir($pulang));
} else {
    echo "Directory not found: $pulang\n";
}
?>
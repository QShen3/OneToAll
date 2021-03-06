package com.qshen.onetoall;

import java.lang.String;
import java.io.File;
import android.os.Environment;
import android.os.Build;
import android.content.Intent;
import android.content.Context;
import android.content.ContentUris;
import android.provider.MediaStore;
import android.provider.DocumentsContract;
import android.net.Uri;
import android.database.Cursor;



public class ImagePicker extends org.qtproject.qt5.android.bindings.QtActivity
{
    public static ImagePicker m_instance;

    public ImagePicker(){
        m_instance = this;

    }

    public static Intent createChoosePhotoIntent() {
        Intent intent = new Intent( Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI );
        intent.setType("image/*");
        return Intent.createChooser(intent, "Select Image");
    }

    public static Intent createCaptureImageIntent(String imageName) {
        Intent intent = new Intent( MediaStore.ACTION_IMAGE_CAPTURE);

        File savedDir = Environment.getExternalStorageDirectory() ;
        File savedImageFile = new File(savedDir, "/DCIM/Camera/" + imageName);

        System.out.println(savedImageFile);
        Uri savedImageUri = Uri.fromFile(savedImageFile);
        intent.putExtra(MediaStore.EXTRA_OUTPUT, savedImageUri);

        return intent;
    }

    public static String getUrl( Intent intent) {
        //System.out.println("Hello world");
        Uri uri = intent.getData();



        final boolean isKitKat = Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT;

                // DocumentProvider
                if (isKitKat && DocumentsContract.isDocumentUri(m_instance, uri)) {
                    // ExternalStorageProvider
                    if (isExternalStorageDocument(uri)) {
                        final String docId = DocumentsContract.getDocumentId(uri);
                        final String[] split = docId.split(":");
                        final String type = split[0];

                        if ("primary".equalsIgnoreCase(type)) {
                            return Environment.getExternalStorageDirectory() + "/" + split[1];
                        }

                        // TODO handle non-primary volumes
                    }
                    // DownloadsProvider
                    else if (isDownloadsDocument(uri)) {

                        final String id = DocumentsContract.getDocumentId(uri);
                        final Uri contentUri = ContentUris.withAppendedId(
                                Uri.parse("content://downloads/public_downloads"), Long.valueOf(id));

                        return getDataColumn(m_instance, contentUri, null, null);
                    }
                    // MediaProvider
                    else if (isMediaDocument(uri)) {
                        final String docId = DocumentsContract.getDocumentId(uri);
                        final String[] split = docId.split(":");
                        final String type = split[0];

                        Uri contentUri = null;
                        if ("image".equals(type)) {
                            contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
                        } else if ("video".equals(type)) {
                            contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
                        } else if ("audio".equals(type)) {
                            contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
                        }

                        final String selection = "_id=?";
                        final String[] selectionArgs = new String[] { split[1] };

                        return getDataColumn(m_instance, contentUri, selection, selectionArgs);
                    }
                }
                // MediaStore (and general)
                else if ("content".equalsIgnoreCase(uri.getScheme())) {
                    return getDataColumn(m_instance, uri, null, null);
                }
                // File
                else if ("file".equalsIgnoreCase(uri.getScheme())) {
                    return uri.getPath();
                }

                return null;


    }
    public static String getDataColumn(Context context, Uri uri, String selection,
                String[] selectionArgs) {

            Cursor cursor = null;
            final String column = "_data";
            final String[] projection = { column };

            try {
                cursor = context.getContentResolver().query(uri, projection, selection, selectionArgs,
                        null);
                if (cursor != null && cursor.moveToFirst()) {
                    final int column_index = cursor.getColumnIndexOrThrow(column);
                    return cursor.getString(column_index);
                }
            } finally {
                if (cursor != null)
                    cursor.close();
            }
            return null;
        }

        /**
         * @param uri
         *            The Uri to check.
         * @return Whether the Uri authority is ExternalStorageProvider.
         */
        public static boolean isExternalStorageDocument(Uri uri) {
            return "com.android.externalstorage.documents".equals(uri.getAuthority());
        }

        /**
         * @param uri
         *            The Uri to check.
         * @return Whether the Uri authority is DownloadsProvider.
         */
        public static boolean isDownloadsDocument(Uri uri) {
            return "com.android.providers.downloads.documents".equals(uri.getAuthority());
        }

        /**
         * @param uri
         *            The Uri to check.
         * @return Whether the Uri authority is MediaProvider.
         */
        public static boolean isMediaDocument(Uri uri) {
            return "com.android.providers.media.documents".equals(uri.getAuthority());
        }


}

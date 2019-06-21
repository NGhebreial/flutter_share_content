package io.flutter.plugins.fluttersharecontent;

import android.content.Intent;
import android.net.Uri;
import android.os.Build;

import androidx.core.content.FileProvider;

import java.io.File;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterShareContentPlugin
 */
public class FlutterShareContentPlugin implements MethodCallHandler {

    private final PluginRegistry.Registrar registrar;

    public FlutterShareContentPlugin(PluginRegistry.Registrar registrar) {
        this.registrar = registrar;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_share_content");
        channel.setMethodCallHandler(new FlutterShareContentPlugin(registrar));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("shareContent")) {
            shareContent(call, result);
        } else {
            result.notImplemented();
        }
    }


    private void shareContent(MethodCall call, Result result) {
        String path = call.argument("path");
        String msg = call.argument("msg");
        String title = call.argument("title");
        title = title == null || title.equals("") ? "Share to" : title;

        Intent share = new Intent(Intent.ACTION_SEND);

        if (path != null) {
            imageIntent(share, path);
        }

        if (msg != null) {
            share.putExtra(Intent.EXTRA_TEXT, msg);
        }

        registrar.activity().startActivity(Intent.createChooser(share, title));
        result.success("Sharing...");
    }

    private void imageIntent(Intent share, String path) {
        File media = new File(path);

        if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {

            Uri apkURI = FileProvider.getUriForFile(
                    registrar.activity().getBaseContext(),
                    registrar.activity().getApplicationContext()
                            .getPackageName() + ".provider", media);

            share.putExtra(Intent.EXTRA_STREAM, apkURI);
        } else
            share.putExtra(Intent.EXTRA_STREAM, Uri.fromFile(media));

        share.setType("image/*");

        share.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
    }
}

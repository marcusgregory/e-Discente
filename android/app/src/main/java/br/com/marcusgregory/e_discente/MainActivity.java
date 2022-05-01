package br.com.marcusgregory.e_discente;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.graphics.Paint;
import androidx.core.graphics.PaintCompat;

import java.util.HashMap;
import java.util.Map;

public class MainActivity extends FlutterActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "emoji_picker_flutter")
        .setMethodCallHandler(
          (call, result) -> {
              if (call.method.equals("isAvailable")) {
      Paint paint = new Paint();
      result.success(PaintCompat.hasGlyph(paint, call.argument("emoji").toString()));
    } else if(call.method.equals("checkAvailability")) {
      Paint paint = new Paint();
      HashMap<String, String> map = call.argument("emoji");
      HashMap<String, String> filtered = new HashMap<>();
      for (Map.Entry entry: map.entrySet()) {
        if(PaintCompat.hasGlyph(paint, entry.getValue().toString())){
          filtered.put(entry.getKey().toString(), entry.getValue().toString());
        }
      }
      result.success(filtered);
    } else {
      result.notImplemented();
    }
          }
        );
  }
}

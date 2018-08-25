package com.dudior.doit;

import android.app.PendingIntent;
import android.content.Intent;
import android.content.IntentFilter;
import android.nfc.NdefMessage;
import android.nfc.NdefRecord;
import android.nfc.NfcAdapter;
import android.nfc.Tag;
import android.nfc.tech.Ndef;
import android.nfc.tech.NdefFormatable;
import android.os.Bundle;
import android.os.Parcelable;
import android.util.Log;
import android.widget.Toast;

import java.io.ByteArrayOutputStream;
import java.io.UnsupportedEncodingException;
import java.util.Locale;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;
import kotlin.NotImplementedError;


public class NfcActivity extends FlutterActivity {
    private static final String CLASS_PATH = "doit:nfc";
    private static final String GET_LAST_TEXT_READ = "getLastTextRead";
    private static final String SET_STATE = "setState";
    private static final String GET_STATE = "getState";
    private static final String SET_TEXT_TO_WRITE = "setTextToWrite";
    private static final String GET_TEXT_TO_WRITE = "getTextToWrite";

    NfcAdapter nfcAdapter;
    String textRead="";
    String textToWrite = "";
    NfcState nfcState = NfcState.NA;
    boolean hasNfc = false;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // nfc init
        nfcAdapter = NfcAdapter.getDefaultAdapter(this);
        hasNfc = nfcAdapter != null && nfcAdapter.isEnabled();
        nfcState = hasNfc ? NfcState.READ : NfcState.NA;

        initMethodChannel();
    }

    private void initMethodChannel() {
        // set channel to call class method from flutter
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(getFlutterView(), CLASS_PATH).setMethodCallHandler(
            new MethodCallHandler() {
                @Override
                public void onMethodCall(MethodCall call, Result result) {
                    switch (call.method) {
                        case GET_LAST_TEXT_READ:
                            result.success(textRead);
                            break;
                        case SET_STATE:
                            String nfcStateString = call.argument("state");
                            nfcState = nfcStateString.equals(NfcState.READ.toString()) ?
                                NfcState.READ :
                                NfcState.WRITE;
                            result.success(nfcStateString);
                            break;
                        case GET_STATE:
                            result.success(nfcState.getId());
                            break;
                        case SET_TEXT_TO_WRITE:
                            textToWrite = call.argument("textToWrite");
                            result.success(textToWrite);
                            break;
                        case GET_TEXT_TO_WRITE:
                            result.success(textToWrite);
                            break;
                        default:
                            result.notImplemented();
                            break;

                    }
                }
            });
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (hasNfc) {
            enableForegroundDispatchSystem();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (hasNfc) {
            disableForegroundDispatchSystem();
        }
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        if (intent.hasExtra(NfcAdapter.EXTRA_TAG)) {
            Toast.makeText(this, "NfcIntent!", Toast.LENGTH_SHORT).show();
            if (nfcState == NfcState.READ) {
                Parcelable[] parcelables = intent.getParcelableArrayExtra(NfcAdapter.EXTRA_NDEF_MESSAGES);
                if (parcelables != null && parcelables.length > 0) {
                    readTextFromMessage((NdefMessage) parcelables[0]);
                } else {
                    Toast.makeText(this, "No NDEF messages found!", Toast.LENGTH_SHORT).show();
                }
            } else if (nfcState == NfcState.WRITE) {
                Tag tag = intent.getParcelableExtra(NfcAdapter.EXTRA_TAG);
                NdefMessage ndefMessage = createNdefMessage(textToWrite);
                writeNdefMessage(tag, ndefMessage);
            } else {
                throw new NotImplementedError("unknown nfc state");
            }
        }
    }

    private void readTextFromMessage(NdefMessage ndefMessage) {
        NdefRecord[] ndefRecords = ndefMessage.getRecords();
        if (ndefRecords != null && ndefRecords.length > 0) {
            NdefRecord ndefRecord = ndefRecords[0];
            textRead = getTextFromNdefRecord(ndefRecord);
        } else {
            Toast.makeText(this, "No NDEF records found!", Toast.LENGTH_SHORT).show();
        }
    }

    private void enableForegroundDispatchSystem() {
        Intent intent = new Intent(this, NfcActivity.class).addFlags(Intent.FLAG_RECEIVER_REPLACE_PENDING);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, intent, 0);
        IntentFilter[] intentFilters = new IntentFilter[]{};
        nfcAdapter.enableForegroundDispatch(this, pendingIntent, intentFilters, null);
    }

    private void disableForegroundDispatchSystem() {
        nfcAdapter.disableForegroundDispatch(this);
    }

    private void formatTag(Tag tag, NdefMessage ndefMessage) {
        try {
            NdefFormatable ndefFormatable = NdefFormatable.get(tag);
            if (ndefFormatable == null) {
                Toast.makeText(this, "Tag is not ndef formatable!", Toast.LENGTH_SHORT).show();
                return;
            }
            ndefFormatable.connect();
            ndefFormatable.format(ndefMessage);
            ndefFormatable.close();
            Toast.makeText(this, "Tag writen!", Toast.LENGTH_SHORT).show();
        } catch (Exception e) {
            Log.e("formatTag", e.getMessage());
        }
    }

    private void writeNdefMessage(Tag tag, NdefMessage ndefMessage) {
        try {
            if (tag == null) {
                Toast.makeText(this, "Tag object cannot be null", Toast.LENGTH_SHORT).show();
                return;
            }
            Ndef ndef = Ndef.get(tag);
            if (ndef == null) {
                // format tag with the ndef format and writes the message.
                formatTag(tag, ndefMessage);
            } else {
                ndef.connect();
                if (!ndef.isWritable()) {
                    Toast.makeText(this, "Tag is not writable!", Toast.LENGTH_SHORT).show();

                    ndef.close();
                    return;
                }
                ndef.writeNdefMessage(ndefMessage);
                ndef.close();
                Toast.makeText(this, "Tag writen!", Toast.LENGTH_SHORT).show();
            }

        } catch (Exception e) {
            Log.e("writeNdefMessage", e.getMessage());
        }
    }


    private NdefRecord createTextRecord(String content) {
        try {
            byte[] language;
            language = Locale.getDefault().getLanguage().getBytes("UTF-8");
            final byte[] text = content.getBytes("UTF-8");
            final int languageSize = language.length;
            final int textLength = text.length;
            final ByteArrayOutputStream payload = new ByteArrayOutputStream(1 + languageSize + textLength);
            payload.write((byte) (languageSize & 0x1F));
            payload.write(language, 0, languageSize);
            payload.write(text, 0, textLength);
            return new NdefRecord(NdefRecord.TNF_WELL_KNOWN, NdefRecord.RTD_TEXT, new byte[0], payload.toByteArray());
        } catch (UnsupportedEncodingException e) {
            Log.e("createTextRecord", e.getMessage());
        }
        return null;
    }


    private NdefMessage createNdefMessage(String content) {
        NdefRecord ndefRecord = createTextRecord(content);
        NdefMessage ndefMessage = new NdefMessage(new NdefRecord[]{ndefRecord});
        return ndefMessage;
    }

    public String getTextFromNdefRecord(NdefRecord ndefRecord) {
        String tagContent = null;
        try {
            byte[] payload = ndefRecord.getPayload();
            String textEncoding = ((payload[0] & 128) == 0) ? "UTF-8" : "UTF-16";
            int languageSize = payload[0] & 0063;
            tagContent = new String(payload, languageSize + 1,
                payload.length - languageSize - 1, textEncoding);
        } catch (UnsupportedEncodingException e) {
            Log.e("getTextFromNdefRecord", e.getMessage(), e);
        }
        return tagContent;
    }

}

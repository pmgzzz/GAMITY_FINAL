package org.gamity.buildingservice.security;

import androidx.security.crypto.EncryptedFile;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;


public class Cryptographer {
    private KeyStoreKeeper keyStoreKeeper;

    public Cryptographer ( KeyStoreKeeper keyStoreKeeper ) {
        if (this.keyStoreKeeper == null)
            this.keyStoreKeeper = keyStoreKeeper;
    }

    public byte[] read (String fileToRead) throws IOException, GeneralSecurityException {
        return read (prepareToRead(fileToRead).openFileInput());
    }
    public byte[] read (File fileToRead) throws IOException, GeneralSecurityException {
        return read (prepareToRead(fileToRead).openFileInput());
    }
    public byte[] read (InputStream inputStream) throws IOException {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        System.out.println("read-test");
        int nextByte = inputStream.read();
        while (nextByte != -1) {
            System.out.print(nextByte);
            byteArrayOutputStream.write(nextByte);
            nextByte = inputStream.read();
        }

        byte[] plaintext = byteArrayOutputStream.toByteArray();
        return plaintext;
    }
    private EncryptedFile prepareToRead (File fileToRead) throws GeneralSecurityException, IOException {
        EncryptedFile encryptedFile = new EncryptedFile.Builder(keyStoreKeeper.getContext(),
                fileToRead,
                keyStoreKeeper.getMasterKey(),
                EncryptedFile.FileEncryptionScheme.AES256_GCM_HKDF_4KB
        ).build();
        return encryptedFile;
    }
    private EncryptedFile prepareToRead (String fileToRead) throws GeneralSecurityException, IOException {
        return prepareToRead (new File(keyStoreKeeper.getContext().getFilesDir(), fileToRead));
    }

    public EncryptedFile prepareToWrite (String fileToWrite) throws GeneralSecurityException, IOException {
        return prepareToWrite (new File(keyStoreKeeper.getContext().getFilesDir(), fileToWrite));
    }

    public EncryptedFile prepareToWrite (File fileToWrite) throws GeneralSecurityException, IOException {
        boolean b = fileToWrite.delete();
        EncryptedFile encryptedFile = new EncryptedFile.Builder(keyStoreKeeper.getContext(),
                fileToWrite,
                keyStoreKeeper.getMasterKey(),
                EncryptedFile.FileEncryptionScheme.AES256_GCM_HKDF_4KB
        ).build();
        return encryptedFile;
    }

    public void write (File fileToWrite, String fileContent) throws GeneralSecurityException, IOException {
        OutputStream outputStream = prepareToWrite (fileToWrite).openFileOutput();
        outputStream.write(toUtf8 (fileContent));
        outputStream.flush();
        outputStream.close();
    }

    public void write (String fileToWrite, String fileContent) throws GeneralSecurityException, IOException {
        OutputStream outputStream = prepareToWrite (fileToWrite).openFileOutput();
        outputStream.write(toUtf8 (fileContent));
        outputStream.flush();
        outputStream.close();
    }

    public byte[] toUtf8 (byte[] InputStream) {
        return toUtf8 (InputStream.toString());
    }
    public byte[] toUtf8 (String InputStream) {
        return InputStream.getBytes(StandardCharsets.UTF_8);
    }
}

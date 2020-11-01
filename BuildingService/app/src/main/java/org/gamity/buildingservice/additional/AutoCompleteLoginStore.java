package org.gamity.buildingservice.additional;


import android.os.FileUtils;

import androidx.annotation.RequiresApi;

import org.gamity.buildingservice.context.ContextKeeper;
import org.gamity.buildingservice.security.Cryptographer;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

import static android.os.Build.VERSION_CODES.O;

public class AutoCompleteLoginStore {
    private String [] phoneArray = { "" };
    private String [] snilsArray = { "" };
    private String PHONE_FILE = "auto_complete_phones";
    private String SNILS_FILE = "auto_complete_snils";
    private Cryptographer cryptographer;

    public AutoCompleteLoginStore (Cryptographer cryptographer) {
        if (this.cryptographer == null)
            this.cryptographer = cryptographer;
        try {
            populatePhoneArrayFromFile ();
            populateSnilsArrayFromFile ();
        } catch (IOException | GeneralSecurityException e) {
            e.printStackTrace();
        }
    }

    private void populatePhoneArrayFromFile () throws IOException, GeneralSecurityException {
        phoneArray = populateArrayFromFile ( PHONE_FILE );
        for (String arrayElement: phoneArray) {
            System.out.println("read phone="+ arrayElement);
        }
    }

    private void populateSnilsArrayFromFile () throws IOException, GeneralSecurityException {
        snilsArray = populateArrayFromFile ( SNILS_FILE );
        for (String arrayElement: snilsArray) {
            System.out.println("read snils="+arrayElement);
        }
    }

    private String [] populateArrayFromFile ( String fileName ) throws IOException, GeneralSecurityException {
        return populateArrayFromFile (new File(ContextKeeper.getContext().getFilesDir(), fileName));
    }

    private String [] populateArrayFromFile ( File fileToRead ) throws IOException, GeneralSecurityException {
        Scanner scanner = new Scanner(fileToRead);
        //Scanner scanner = new Scanner(cryptographer.read(fileToRead).toString());
        List<String> lines = new ArrayList<String>();
        while (scanner.hasNextLine()) {
            lines.add(scanner.nextLine());
        }
        //return lines.toArray(new String[0]);
        return lines.toArray(new String[lines.size()]);
    }


    public void appendPhoneList ( String newPhone ) throws IOException, GeneralSecurityException {
        phoneArray = appendList (phoneArray, newPhone);
        savePhones ();
    }
    public void appendSnilsList ( String newSnils ) throws IOException, GeneralSecurityException {
        snilsArray = appendList (snilsArray, newSnils);
        saveSnils ();
    }

    public String [] appendList ( String[] array, String newArrayElement ) throws IOException {
        if (newArrayElement == null) return array;
        for (String phone : array) {
            if (phone.equals(newArrayElement)) return array;
        }
        return append(array, newArrayElement);
    }

    static <T> T[] append(T[] arr, T element) {
        final int N = arr.length;
        arr = Arrays.copyOf(arr, N + 1);
        arr[N] = element;
        return arr;
    }

    public String[] getPhoneArray () {
        return phoneArray;
    }

    public String[] getSnilsArray () {
        return snilsArray;
    }

    private void savePhones () throws IOException, GeneralSecurityException {
        saveArray ( phoneArray, PHONE_FILE );
    }

    private void saveSnils () throws IOException, GeneralSecurityException {
        saveArray ( snilsArray, SNILS_FILE );
    }


    private void saveArray (String[] array, String fileName ) throws IOException, GeneralSecurityException {
        File fileToWrite = new File(ContextKeeper.getContext().getFilesDir(), fileName);
        PrintWriter printWriter = new PrintWriter(new FileWriter( fileToWrite ));
        for (String arrayElement : array) {
            System.out.println("saved arrayElement="+arrayElement);
            printWriter.println(arrayElement);
        }
        printWriter.close();
        InputStream inputStream = new FileInputStream(fileToWrite);
        String str = String.join("\n", array);
        System.out.println("test inputstream = " + str);
        //cryptographer.write(fileToWrite, str);
    }

}

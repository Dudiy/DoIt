package com.dudior.doit;

public enum NfcState {
    READ("1"),
    WRITE("2"),
    NA("0");

    private String id;

    NfcState(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }
}

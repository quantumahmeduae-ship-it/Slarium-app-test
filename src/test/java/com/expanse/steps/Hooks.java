package com.expanse.steps;

import com.github.tomakehurst.wiremock.WireMockServer;
import io.cucumber.java.After;
import io.cucumber.java.Before;
import static com.github.tomakehurst.wiremock.core.WireMockConfiguration.wireMockConfig;

public class Hooks {
    private static WireMockServer wireMockServer;

    @Before
    public void startServer() {
        if (wireMockServer == null) {
            wireMockServer = new WireMockServer(wireMockConfig().port(8080));
            wireMockServer.start();
        }
    }

    @After
    public void stopServer() {
        if (wireMockServer != null) {
            wireMockServer.stop();
            wireMockServer = null;
        }
    }
}

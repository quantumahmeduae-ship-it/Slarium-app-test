package com.expanse.steps;

import io.cucumber.java.en.*;
import io.restassured.response.Response;
import static com.github.tomakehurst.wiremock.client.WireMock.*;
import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.*;

public class ExpanseSteps {
    private Response response;
    private final String BASE_URL = "http://localhost:8080";

    @Given("the API is stubbed for {string} at {string} with status {int} and body {string}")
    public void universalStub(String method, String endpoint, int status, String body) {
        // Convert single quotes to double quotes for valid JSON
        String jsonBody = body.replace("'", "\"");
        
        if(method.equalsIgnoreCase("POST")) {
            stubFor(post(urlEqualTo(endpoint))
                .willReturn(aResponse()
                    .withStatus(status)
                    .withHeader("Content-Type", "application/json")
                    .withBody(jsonBody)));
        } else if(method.equalsIgnoreCase("GET")) {
            stubFor(get(urlEqualTo(endpoint))
                .willReturn(aResponse()
                    .withStatus(status)
                    .withHeader("Content-Type", "application/json")
                    .withBody(jsonBody)));
        }
    }

    @When("I call the {string} API {string} with body {string}")
    public void callApi(String method, String endpoint, String body) {
        String jsonBody = body.replace("'", "\"");
        if(method.equalsIgnoreCase("POST")) {
            response = given().baseUri(BASE_URL).contentType("application/json").body(jsonBody).post(endpoint);
        } else {
            response = given().baseUri(BASE_URL).get(endpoint);
        }
    }

    @Then("the response code should be {int}")
    public void checkStatus(int code) {
        response.then().statusCode(code);
    }

    @Then("the response should contain {string} as {string}")
    public void checkBody(String path, String value) {
        response.then().body(path, containsString(value));
    }
}

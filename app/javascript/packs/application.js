// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
require("jquery");

import Rails from "@rails/ujs";
import "@hotwired/turbo-rails";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
import { Application } from "stimulus";
import { definitionsFromContext } from "stimulus/webpack-helpers";
import $ from "jquery";
window.$ = $;

const application = Application.start();
const context = require.context("../controllers/", true, /.js$/);
application.load(definitionsFromContext(context));

Rails.start();
ActiveStorage.start();

import "../stylesheets/style";
import "slick-carousel";
import "slick-carousel/slick/slick.scss";
import "slick-carousel/slick/slick-theme.scss";
import "jquery-validation/dist/jquery.validate";
import "bootstrap";
import "bootstrap-icons/font/bootstrap-icons.css";
import ("@client-side-validations/client-side-validations");
import ("../plugins/simple-form.bootstrap4");
import { initTooltips } from "../components/init_tooltips";
initTooltips();

$(document).on("ajax:error", function(xhr, status, error){
  if(xhr.status === "401") {
    console.log('pudim')  
  }
});
$(document).ready(function() {

  // Wrap any <em> tags beginning with "NOTE:", "WARNING:", etc in the
  // corresponding Bootstrap alert
  var alertStates = ["info", "success", "warning", "danger"];
  for (i = 0; i < alertStates.length; i++) {
    var alert = alertStates[i];
    if (alert == "info") {
      var alertLabel = "note";
    } else {
      var alertLabel = alert;
    };
    var alerts = $("em:contains(" + alertLabel.toUpperCase() + ")")
    $("em:contains(" + alertLabel.toUpperCase() + ") > a").addClass('alert-link')
    $.each(alerts, function(index,alertElement) {
      var alertContent = alertElement.innerHTML;
      alertContent = alertContent.replace(alertLabel.toUpperCase(), "<strong>" + alertLabel.toUpperCase() + "</strong>");
      alertElement.innerHTML = "<div class='alert alert-" + alert + "'>" + alertContent + "</div>";
    });
  };

  var dts = $("#documentation > dl > dt");
  $.each(dts, function(index, dt) {
    $("<hr/>").insertBefore(dt);
  });

  $(".hamburger-button").click(function() {
    $(this).toggleClass("collapsed");
    $(".toc-collapse").slideToggle();
  });
});

$(document).ready(function() {

  var alertStates = ["note", "success", "warning", "danger"];
  for (i = 0; i < alertStates.length; i++) {
    var alert = alertStates[i];
    var alerts = $("em:contains(" + alert.toUpperCase() + ")")
    $.each(alerts, function(index,alertHTML) {
      var alertContent = alertHTML.innerHTML;
      alertContent = alertContent.replace(alert.toUpperCase(), "<strong>" + alert.toUpperCase() + "</strong>");
      alertHTML.innerHTML = "<div class='alert alert-" + alert + "'>" + alertContent + "</div>";
    });
  };

  $(":header:contains('Ubuntu/Debian')").addClass("ubuntu").prepend("<i class='fl-ubuntu'></i>");
  $(":header:contains('RHEL/CentOS')").addClass("centos").prepend("<i class='fl-centos'></i>");

  var dts = $("#documentation > dl > dt");
  $.each(dts, function(index, dt) {
    $("<hr/>").insertBefore(dt);
  });

  $(".hamburger-button").click(function() {
    $(this).toggleClass("collapsed");
    $(".toc-collapse").slideToggle();
  });
});

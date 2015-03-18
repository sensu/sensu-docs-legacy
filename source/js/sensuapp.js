$(document).ready(function() {
  $("h2:contains('Ubuntu/Debian')").addClass('ubuntu').prepend("<i class='fl-ubuntu'></i>");
  $("h2:contains('CentOS/RHEL')").addClass('centos').prepend("<i class='fl-centos'></i>");
});

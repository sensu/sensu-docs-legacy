$(document).ready(function() {
  $(":header:contains('Ubuntu/Debian')").addClass('ubuntu').prepend("<i class='fl-ubuntu'></i>");
  $(":header:contains('CentOS/RHEL')").addClass('centos').prepend("<i class='fl-centos'></i>");
});

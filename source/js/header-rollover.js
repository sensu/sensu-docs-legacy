/*
 * Puts a link icon at the end of header anchor tags
 * when a user mouses over them. Useful for linking
 * directly to doc subsections.
 *
 * Source: http://ben.balter.com/2014/03/13/pages-anchor-links/
 * Date: 03/03/2015
 */

$(function() {
  return $("h1, h2, h3, h4, h5, h6").each(function(i, el) {
    var $el, icon, id;
    $el = $(el);
    id = $el.attr('id');
    icon = '<i class="fa fa-link"></i>';
    if (id) {
      return $el.append($("<a />").addClass("header-link").attr("href", "#" + id).html(icon));
    }
  });
});

$(function() {
    $('.open-feedback').click($('#fdbk_tab').click);
});

function guideMenu(){
  if (document.getElementById('index-dialog').style.display == "none") {
    document.getElementById('index-dialog').style.display = "block";
  } else {
    document.getElementById('index-dialog').style.display = "none";
  }
}

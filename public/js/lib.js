goToPath = function(path) { 
  window.location.href = path;
}

nicePrompt = function(title,cb) {
  swal({
    title: title,
    html: '<p><input id="swal-prompt-input-field">',
  },
  function() {
    var val = $('#swal-prompt-input-field').val();
    if (val && cb) { cb(val); }    
  });
}

$.fn.serializeObject = function()
{
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};
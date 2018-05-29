$(document).ready(function () {
    $.fn.autocomplete = function(arr, onEnterPressed) {
        inp = $(this);
        var currentFocus;
        inp.on("input", function (e) {
            var a, b, i, val = $(this).val();
            closeAllLists();
            if (!val) { return false; }
            currentFocus = -1;
            a = $("<div></div>");            
            a.addClass("autocomplete-items");
            $(this).after(a);
            for (i = 0; i < arr.length; i++) {
                if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
                    b = $("<div></div>");
                    b.html("<strong>" + arr[i].substr(0, val.length) + "</strong>");
                    b.append(arr[i].substr(val.length));
                    b.append("<input type='hidden' value='" + arr[i] + "'>");
                    b.on("click", function (e) {

                        inp.val($(this).children("input").val());

                        closeAllLists();
                    });
                    a.append(b);
                }
            }
        });

        inp.on("keydown", function (e) {
            var x = $(".autocomplete .autocomplete-items");
            if (x) x = x.children("div");
            if (e.keyCode == 40) {
                currentFocus++;
                addActive(x);
            } else if (e.keyCode == 38) { 
                currentFocus--;                
                addActive(x);
            } else if (e.keyCode == 13) {                
                if (currentFocus > -1) {                    
                    e.preventDefault();
                    if (x) x.eq(currentFocus).trigger("click");
                }else{
                    onEnterPressed();
                }
            }
        });
        function addActive(x) {            
            if (!x) return false;            
            removeActive(x);
            if (currentFocus >= x.length) currentFocus = 0;
            if (currentFocus < 0) currentFocus = (x.length - 1);
            
            x.eq(currentFocus).addClass("autocomplete-active");
        }
        function removeActive(x) {            
            for (var i = 0; i < x.length; i++) {
                x.eq(i).removeClass("autocomplete-active");
            }
        }
        function closeAllLists(elmnt) {    
            currentFocus = -1;        
            var x = $(".autocomplete-items");
            for (var i = 0; i < x.length; i++) {
                if (elmnt != x[i] && elmnt != inp) {
                    x.eq(i).remove();
                }
            }
        }
        
        $(document).on("click", function (e) {
            closeAllLists(e.target);
        });
    }
});
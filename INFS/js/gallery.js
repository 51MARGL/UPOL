$(document).ready(function () {

    var interval_id;
    var $imageList;
    var slideIndex;

    $(window).scroll(function () {
        if ($(this).scrollTop() >= 500) {
            $('.scrollToTop').fadeIn();
        } else {
            $('.scrollToTop').fadeOut();
        }
    });

    $('.scrollToTop').click(function () {
        $('html, body').animate({ scrollTop: 0 }, 800);
        return false;
    });

    $('main .row .column > div').click(function () {
        var $clickedImage = $(this).find('img:first');
        slideIndex = $imageList.index($clickedImage);

        $('.main-image').find('img:first').attr("src", $clickedImage.attr("src"));
        $('.photo-viewer').css({ "zIndex": "100" });
        $('.photo-viewer').animate({ opacity: 1 }, 1000);
    })

    $('.close').click(function () {
        $('.photo-viewer').animate({ opacity: 0 }, 1000, function () {
            $('.photo-viewer').css({ "zIndex": "-100" });
        });
        if (interval_id) {
            clearInterval(interval_id);
            interval_id = 0;
        }
        $('.pause').css({ "display": "none" })
        $('.play').css({ "display": "block" })
    });

    $('.next').click(function () {
        slideIndex = (slideIndex + 1) % $imageList.length;
        displaySlideImage(slideIndex);
    })

    $('.prev').click(function () {
        slideIndex = (slideIndex - 1) % $imageList.length;
        displaySlideImage(slideIndex);
    })

    $('.play').click(function () {
        $(this).css({ "display": "none" })
        $('.pause').css({ "display": "block" })
        interval_id = setInterval(function () {
            displaySlideImage(slideIndex = (slideIndex + 1) % $imageList.length);
        }, 3000);
    });

    $('.pause').click(function () {
        $(this).css({ "display": "none" })
        $('.play').css({ "display": "block" })
        if (interval_id) {
            clearInterval(interval_id);
            interval_id = 0;
        }
    });

    function displaySlideImage(index) {
        if (index > $imageList.length)
            slideIndex = 0;
        else if (index < 0)
            slideIndex = $imageList.length - 1;
        $('.main-image').find('img:first').fadeOut(500, function () {
            $('.main-image').find('img:first').attr("src", $imageList.eq(slideIndex).attr("src"));
            $('.main-image').find('img:first').fadeIn(500);
        });
    }

    //main
    $imageList = $('main .row .column > div').find('img:first');
    slideIndex = 0;
});
$(document).ready(function () {

    var slideIndex = 0;
    var interval_id;

    //foreground vs background
    $(window).on("blur focus", function (e) {
        switch (e.type) {
            case "focus":
                if (!interval_id)
                    interval_id = setInterval(slideThroughList, 6000);
                break;
            case "blur":
                clearInterval(interval_id);
                interval_id = 0;
                break;
        }
    })

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

    function slideThroughList() {
        var $postList = $(".slider .post-preview");
        var $bigPost = $(".slider .selected-post-preview");
        var temp = $bigPost.html();

        $postList.eq(slideIndex).animate({
            right: '500px',
            opacity: 0
        }, 1000, function () {
            var offset1 = $bigPost.offset();

            $bigPost.before('<article class="selected-post-preview white">' +
                $postList.eq(slideIndex).html() +
                '</article>');
            $(".slider .selected-post-preview-container")
                .find('article').eq(1)
                .fadeOut(1000, function () {
                    $(".slider .selected-post-preview-container").find('article').eq(1).remove();
                });
            $postList.eq(slideIndex).html(temp);
            $postList.eq(slideIndex).animate({
                right: '0px',
                opacity: 1
            }, 1000, function () {
                slideIndex= (slideIndex + 1) % $postList.length;               
            });
        });
    }

    //main
    if (!interval_id)
        interval_id = setInterval(slideThroughList, 6000);
});
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
                slideIndex = (slideIndex + 1) % $postList.length;
            });
        });
    }

    function loadSliderAsync() {
        $.ajax({
            url: '/index.php?controller=posts&action=getCount',
            type: 'GET',
            data: "count=6",
            success: function (data) {
                $data = $(data).filter("div");
                $(".slider .selected-post-preview").html($data.eq(0).html());
                $(".slider .post-preview").each(function (index, element) {
                    var elem = $(element);

                    elem.html($data.eq(index + 1).html());
                });

                if (!interval_id)
                    interval_id = setInterval(slideThroughList, 6000);
            }
        });
    }

    $(".world-news .cat-selector").on("click", function () {
        category = $(this).data("category");
        $(".world-news .cat-selector.kinda-blue").removeClass("kinda-blue")
        $(this).addClass("kinda-blue");
        $(".world-news .post-block").data("coffset",0);
        loadWorldAsync(category, 0, '+');
    });

    $(".world-news").on("click", ".btn-left.active", function () {
        $(".world-news .btn-right").addClass("active")
        max=$(".world-news .cat-selector.kinda-blue").data("max-length");
        current = $(".world-news .post-block").data("coffset");
        if((current - 12) < 0){
            $(this).removeClass("active");
        }else{
            current = current - 12;
            $(".world-news .post-block").data("coffset",current);
            loadWorldAsync($(".world-news .cat-selector.kinda-blue").data("category"), current, '+');
        }         
    });

    $(".world-news").on("click", ".btn-right.active", function () {
        $(".world-news .btn-left").addClass("active")
        max=$(".world-news .cat-selector.kinda-blue").data("max-length");
        current = $(".world-news .post-block").data("coffset");
        if((current + 12) > max){
            $(this).removeClass("active");
        }else{
            current = current + 12;
            $(".world-news .post-block").data("coffset",current);
            loadWorldAsync($(".world-news .cat-selector.kinda-blue").data("category"), current, '-');
        }        
    });

    $(".fashion").on("click", ".btn-left.active", function () {
        $(".fashion .btn-right").addClass("active")
        max=$(".fashion").data("max-length");
        current = $(".fashion .post-block").data("coffset");
        if((current - 3) < 0){
            $(this).removeClass("active");
        }else{
            current = current - 3;
            $(".fashion .post-block").data("coffset",current);
            loadFashionAsync(current, '+');
        }         
    });

    $(".fashion").on("click", ".btn-right.active", function () {
        $(".fashion .btn-left").addClass("active")
        max=$(".fashion").data("max-length");
        current = $(".fashion .post-block").data("coffset");
        if((current + 3) > max){
            $(this).removeClass("active");
        }else{
            current = current + 3;
            $(".fashion .post-block").data("coffset",current);
            loadFashionAsync(current, '-');
        }        
    });

    $(".lifestyle").on("click", ".btn-left.active", function () {
        $(".lifestyle .btn-right").addClass("active")
        max=$(".lifestyle").data("max-length");
        current = $(".lifestyle .post-block").data("coffset");
        if((current - 4) < 0){
            $(this).removeClass("active");
        }else{
            current = current - 4;
            $(".lifestyle .post-block").data("coffset",current);
            loadLifestyleAsync(current, '+');
        }         
    });

    $(".lifestyle").on("click", ".btn-right.active", function () {
        $(".lifestyle .btn-left").addClass("active")
        max=$(".lifestyle").data("max-length");
        current = $(".lifestyle .post-block").data("coffset");
        if((current + 4) > max){
            $(this).removeClass("active");
        }else{
            current = current + 4;
            $(".lifestyle .post-block").data("coffset",current);
            loadLifestyleAsync(current, '-');
        }        
    });

    $(".sports").on("click", ".btn-left.active", function () {
        $(".sports .btn-right").addClass("active")
        max=$(".sports").data("max-length");
        current = $(".sports .post-block").data("coffset");
        if((current - 5) < 0){
            $(this).removeClass("active");
        }else{
            current = current - 5;
            $(".sports .post-block").data("coffset",current);
            loadSportsAsync(current, '+');
        }         
    });

    $(".sports").on("click", ".btn-right.active", function () {
        $(".sports .btn-left").addClass("active")
        max=$(".sports").data("max-length");
        current = $(".sports .post-block").data("coffset");
        if((current + 5) > max){
            $(this).removeClass("active");
        }else{
            current = current + 5;
            $(".sports .post-block").data("coffset",current);
            loadSportsAsync(current, '-');
        }        
    });

    $(".technology").on("click", ".btn-left.active", function () {
        $(".technology .btn-right").addClass("active")
        max=$(".technology").data("max-length");
        current = $(".technology .post-block").data("coffset");
        if((current - 2) < 0){
            $(this).removeClass("active");
        }else{
            current = current - 2;
            $(".technology .post-block").data("coffset",current);
            loadTechnologyAsync(current, '+');
        }         
    });

    $(".technology").on("click", ".btn-right.active", function () {
        $(".technology .btn-left").addClass("active")
        max=$(".technology").data("max-length");
        current = $(".technology .post-block").data("coffset");
        if((current + 2) > max){
            $(this).removeClass("active");
        }else{
            current = current + 2;
            $(".technology .post-block").data("coffset",current);
            loadTechnologyAsync(current, '-');
        }        
    });

    $(".food-health").on("click", ".btn-left.active", function () {
        $(".food-health .btn-right").addClass("active")
        max=$(".food-health").data("max-length");
        current = $(".food-health .post-block").data("coffset");
        if((current - 4) < 0){
            $(this).removeClass("active");
        }else{
            current = current - 4;
            $(".food-health .post-block").data("coffset",current);
            loadFoodHealthAsync(current, '+');
        }         
    });

    $(".food-health").on("click", ".btn-right.active", function () {
        $(".food-health .btn-left").addClass("active")
        max=$(".food-health").data("max-length");
        current = $(".food-health .post-block").data("coffset");
        if((current + 4) > max){
            $(this).removeClass("active");
        }else{
            current = current + 4;
            $(".food-health .post-block").data("coffset",current);
            loadFoodHealthAsync(current, '-');
        }        
    });

    function updateArticles(array, data, direction) {
        if (direction === '-'){
            array = $(array.get().reverse());
            data = $(data.get().reverse());
        }
        array.each(function (index, element) {
            $(element).delay(50 * index).animate({
                right: direction + '500px',
                opacity: 0
            }, 400, function () {
                htmlData = data.eq(index).html();
                $(element).html(htmlData || "");
                $(element).css({ right: direction === '+' ? '-500px' : '500px', display: htmlData ? "flex" : "none" });
                $(element).delay(50 * index).animate({
                    right: '0px',
                    opacity: 1
                }, 400, function () {

                });
            });
        });
    }

    function loadWorldAsync(category, offset, direction) {
        $.ajax({
            url: '/index.php?controller=posts&action=getByCategoryDetailed',
            type: 'GET',
            data: "category=" + category + "&count=3&offset=" + offset,
            success: function (data) {
                $data = $(data).filter("div");
                updateArticles($(".world-news .post-preview-detailed"), $data, direction);
            }
        });
        $.ajax({
            url: '/index.php?controller=posts&action=getByCategory',
            type: 'GET',
            data: "category=" + category + "&count=9&offset=" + (parseInt(offset) + 3),
            success: function (data) {
                $data = $(data).filter("div");
                updateArticles($(".world-news .post-preview"), $data, direction);
            }
        });
    }

    function loadFashionAsync(offset, direction) {
        $.ajax({
            url: '/index.php?controller=posts&action=getByCategoryDetailed',
            type: 'GET',
            data: "category=Fashion&count=3&offset=" + offset,
            success: function (data) {
                $data = $(data).filter("div");
                updateArticles($(".fashion .post-preview-detailed"), $data, direction);
            }
        });
    }

    function loadLifestyleAsync(offset, direction) {
        $.ajax({
            url: '/index.php?controller=posts&action=getByCategory',
            type: 'GET',
            data: "category=Lifestyle&count=4&offset=" + offset,
            success: function (data) {
                $data = $(data).filter("div");
                updateArticles($(".lifestyle .post-preview-large"), $data.eq(0), direction);
                updateArticles($(".lifestyle .post-preview"), $data.slice(1), direction);
            }
        });
    }

    function loadSportsAsync(offset, direction) {
        $.ajax({
            url: '/index.php?controller=posts&action=getByCategoryDetailed',
            type: 'GET',
            data: "category=Sports&count=1&offset=" + offset,
            success: function (data) {
                $data = $(data).filter("div");
                updateArticles($(".sports .post-preview-detailed"), $data, direction);
            }
        });
        $.ajax({
            url: '/index.php?controller=posts&action=getByCategory',
            type: 'GET',
            data: "category=Sports&count=4&offset=" + (parseInt(offset) + 1),
            success: function (data) {
                $data = $(data).filter("div");
                updateArticles($(".sports .post-preview"), $data, direction);
            }
        });
    }

    function loadTechnologyAsync(offset, direction) {
        $.ajax({
            url: '/index.php?controller=posts&action=getByCategory',
            type: 'GET',
            data: "category=Technology&count=2&offset=" + offset,
            success: function (data) {
                $data = $(data).filter("div");
                updateArticles($(".technology .post-preview-large"), $data, direction);
            }
        });
    }

    function loadFoodHealthAsync(offset, direction) {
        $.ajax({
            url: '/index.php?controller=posts&action=getByCategory',
            type: 'GET',
            data: "category=food-health&count=4&offset=" + offset,
            success: function (data) {
                $data = $(data).filter("div");
                updateArticles($(".food-health .post-preview"), $data, direction)
            }
        });
    }

    function loadRecenthAsync() {
        $.ajax({
            url: '/index.php?controller=posts&action=getCount',
            type: 'GET',
            data: "count=4",
            success: function (data) {
                $data = $(data).filter("div");               
                $("aside .recent .post-preview").each(function (index, element) {
                    $(element).html($data.eq(index).html());
                });
            }
        });
    }

    //main
    loadSliderAsync();
    loadWorldAsync("World", 0, '+');
    loadFashionAsync(0, '+');
    loadLifestyleAsync(0, '+');
    loadSportsAsync(0, '+');
    loadTechnologyAsync(0, '+');
    loadFoodHealthAsync(0, '+');
    loadRecenthAsync();
});
<?php
$pagination = "";
if ($lastpage > 1) {
    $pagination .= "<ul class='pagination pg-dark'>";
    if ($pageNum > $counter + 1) {
        $pagination .= "<li class=\"page-item prev\"><a class='page-link' href=\"$targetpage/$prev\">Prev</a></li>";
    } else {
        $pagination .= "<li class=\"page-item disabled prev\"><a class='page-link' href=\"$targetpage/$prev\">Prev</a></li>";
    }

    if ($lastpage < 7 + ($adjacents * 2)) {
        for ($counter = 1; $counter <= $lastpage; $counter++) {
            if ($counter == $pageNum) {
                $pagination .= "<li class=\"page-item active\"><a href='' class='page-link'>$counter</a></li>";
            } else {
                $pagination .= "<li class=\"page-item\"><a class='page-link' href=\"$targetpage/$counter\">$counter</a></li>";
            }

        }
    } elseif ($lastpage > 5 + ($adjacents * 2)) //enough pages to hide some
    {
//close to beginning; only hide later pages
        if ($pageNum < 1 + ($adjacents * 2)) {
            for ($counter = 1; $counter < 4 + ($adjacents * 2); $counter++) {
                if ($counter == $pageNum) {
                    $pagination .= "<li class=\"page-item active\"><a href='' class='page-link'>$counter</a></li>";
                } else {
                    $pagination .= "<li class=\"page-item\"><a class='page-link' href=\"$targetpage/$counter\">$counter</a></li>";
                }

            }
            $pagination .= "<li>...</li>";
            $pagination .= "<li class=\"page-item\"><a class='page-link' href=\"$targetpage/$lastpage\">$lastpage</a></li>";
        }
//in middle; hide some front and some back
        elseif ($lastpage - ($adjacents * 2) > $pageNum && $pageNum > ($adjacents * 2)) {
            $pagination .= "<li class=\"page-item\"><a class='page-link' href=\"$targetpage/1\">1</a></li>";
            $pagination .= "<li>...</li>";
            for ($counter = $pageNum - $adjacents; $counter <= $pageNum + $adjacents; $counter++) {
                if ($counter == $pageNum) {
                    $pagination .= "<li class=\"page-item active\"><a href='' class='page-link'>$counter</a></li>";
                } else {
                    $pagination .= "<li class=\"page-item\"><a class='page-link' href=\"$targetpage/$counter\">$counter</a></li>";
                }

            }
            $pagination .= "<li>...</li>";
            $pagination .= "<li class=\"page-item\"><a class='page-link' href=\"$targetpage/$lastpage\">$lastpage</a></li>";
        }
//close to end; only hide early pages
        else {
            $pagination .= "<li class=\"page-item\"><a class='page-link' href=\"$targetpage/1\">1</a></li>";
            $pagination .= "<li>...</li>";
            for ($counter = $lastpage - (2 + ($adjacents * 2)); $counter <= $lastpage;
                $counter++) {
                if ($counter == $pageNum) {
                    $pagination .= "<li class=\"page-item active\"><a href='' class='page-link'>$counter</a></li>";
                } else {
                    $pagination .= "<li class=\"page-item\"><a class='page-link' href=\"$targetpage/$counter\">$counter</a></li>";
                }

            }
        }
    }

//next button
    if ($pageNum < $counter - 1) {
        $pagination .= "<li class=\"page-item next\"><a class='page-link' href=\"$targetpage/$next\">Next</a></li>";
    } else {
        $pagination .= "<li class=\"page-item disabled next\"><a class='page-link' href=\"$targetpage/$next\">Next</a></li>";
    }

    $pagination .= "</ul>\n";
    echo $pagination;
}

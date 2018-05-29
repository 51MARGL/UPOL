$(document).ready(function(){
    $.fn.tagsForm = function () {
        let $hiddenInput = $(".tags-form input[type='hidden']"),
            $mainInput = $(".tags-form input[type='text']"),
            tags = [];

        if ($mainInput.val().length > 0){
            $mainInput.val().split(",").forEach(function (t){
                addTag(t);
            });
            $mainInput.val("");
        }
        $mainInput.on('input', function () {
            let enteredTags = $mainInput.val().split(" ");
            if (enteredTags.length > 1) {
                enteredTags.forEach(function (t) {
                    let filteredTag = filterTag(t);
                    if (filteredTag.length > 0)
                        addTag(filteredTag);
                });
                $mainInput.val("");
            }
        });

        $mainInput.on('keydown', function (e) {
            let keyCode = e.keyCode;
            if (keyCode === 8 && $mainInput.val().length === 0 && tags.length > 0) {
                removeTag(tags.length - 1);
            }
        });

        function addTag(text) {
            let tag = {
                text: text,
                element: $("<div class='btn btn-dark'></div>"),
            };

            tag.element.html(tag.text);
            tags.push(tag);

            let $closeBtn = $("<span class='badge badge-light delete-tag'>X</span>");

            $closeBtn.on('click', function () {
                removeTag(tags.indexOf(tag));
            });
            tag.element.append($closeBtn);


            $mainInput.before(tag.element);

            refreshTags();
        }

        function removeTag(index) {
            let tag = tags[index];
            tags.splice(index, 1);
            tag.element.remove();
            refreshTags();
        }

        function refreshTags() {
            let tagsList = [];
            tags.forEach(function (t) {
                tagsList.push(t.text);
            });
            $hiddenInput.val(tagsList.join(','));
        }

        function filterTag(tag) {
            var fTag = tag.replace(/[^\w-]/, '-').trim();
            return tags.filter(t => t.text === fTag).length === 0 ? fTag : "";
        }
    }
})
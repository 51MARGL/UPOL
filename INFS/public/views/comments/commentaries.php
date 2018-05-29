<?php
function load_comment($comment)
{?>
    <li>
        <article>
            <img src="<?php echo empty($comment->author->profile_img) ? "/uploader/files/profiledefault.png" : htmlspecialchars($comment->author->profile_img); ?>" alt="profile picture" />
            <div class="post-content">
                <h3><?php echo empty($comment->author->first_name) ? htmlspecialchars($comment->u_name) : htmlspecialchars($comment->author->first_name . " " . $comment->author->second_name); ?></h3>
                <p>
                    <?php echo htmlspecialchars($comment->text) ?>
                </p>
                <div class="post-metadata">
                    <div class="reply-to" data-id="<?php echo $comment->id ?>">
                        <img src="/public/img/index/reply-comment.png" alt="reply">
                        <span>Reply</span>
                    </div>
                    <?php if ($_SESSION['logged_in'] && (unserialize($_SESSION['current_user'])->rights == 'SA'
                                || unserialize($_SESSION['current_user'])->id == $post->author->id
                                || unserialize($_SESSION['current_user'])->id == $comment->author->id)) {?>
                        <div class="delete-reply" data-id="<?php echo $comment->id ?>">
                            <span><i>X</i> Delete</span>
                        </div>
                        <?php }?>
                    <time datetime="<?php echo htmlspecialchars($comment->time); ?>">
                        <?php echo (new DateTime($comment->time))->format('F d, Y'); ?>
                    </time>
                </div>
                <ul class="sub-comments">
                    <?php foreach (Commentary::get_by_reply_id($comment->id) as $rep_comment) {
                        load_comment($rep_comment);
                    }?>
                </ul>
            </div>
        </article>
    </li>
<?php }?>

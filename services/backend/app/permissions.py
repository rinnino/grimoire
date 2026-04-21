def is_article_owner(article, current_user: dict) -> bool:
    return article.author_id == current_user["id"]

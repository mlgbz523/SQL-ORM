const express = require('express');
const router = express.Router();
const { Article } = require('../../models/article');
//查询文章列表 GET /admin/articles


router.get('/', (req, res) => {
    const articles = Article.findAll();
    res.json({
        message:'查询文章列表'
    });
});

module.exports = router;
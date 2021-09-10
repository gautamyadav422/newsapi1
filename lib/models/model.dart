class NewsQueryModel {
  late String newsHead;
  late String newsDes;
  late String newsImg;
  late String newUrl;

  NewsQueryModel(
      {this.newsHead = "News HeadLines",
      this.newsDes = "News Descriptions",
      this.newsImg = "Image File",
      this.newUrl = "Image Url"});

  factory NewsQueryModel.fromMap(Map news) {
    return NewsQueryModel(
      newsHead: news["title"],
      newsDes: news["description"],
      newsImg: news["urlToImage"],
      newUrl: news["url"],
    );
  }
}

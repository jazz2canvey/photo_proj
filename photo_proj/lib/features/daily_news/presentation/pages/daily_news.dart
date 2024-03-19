import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_proj/features/daily_news/data/models/image_args.dart';
import 'package:photo_proj/features/daily_news/presentation/bloc/article_bloc.dart';
import 'package:photo_proj/features/daily_news/presentation/bloc/article_state.dart';
import 'package:photo_proj/features/daily_news/presentation/pages/image_in_detail.dart';

class DailyNews extends StatelessWidget {
  const DailyNews({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Daily News",),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body: BlocBuilder<ArticleBloc, ArticleState> (

        builder: (_, state) {

          if (state is ArticleLoading) {

            return const Center(child: CupertinoActivityIndicator(),);

          } else if (state is ArticleException) {

            return const Center(child: Icon(Icons.refresh),);

          } else if (state is ArticleDone) {

            print("state.articles!.articles.length: ${state.articles!.articles.length}");

            return ListView.builder(
              key: const Key("list_view_builder"),
                itemCount: state.articles!.articles.length,
                itemBuilder: (context, index) {

                  print("Articles length: ${state.articles!.articles.length}");
                  print("Title: ${state.articles!.articles[index].title}");
                  print("IMAGE: ${state.articles!.articles[index].urlToImage}");

                  return InkWell(

                    onTap: () {

                      Navigator.pushNamed(context,
                        ImageInDetail.routeName,
                        arguments: ImageArguments(
                          state.articles!.articles[index].author ?? "Pinch to zoom",
                          state.articles!.articles[index].urlToImage ?? "https://img.etimg.com/thumb/msid-108581595,width-1200,height-630,imgsize-44210,overlay-economictimes/photo.jpg",
                        ),
                      );
                    },

                    child: Container(
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
                      child: CachedNetworkImage(
                        imageUrl: state.articles!.articles[index].urlToImage ?? "https://img.etimg.com/thumb/msid-108581595,width-1200,height-630,imgsize-44210,overlay-economictimes/photo.jpg",
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  );
                }
            );
          }

          return const SizedBox();
        },
      ),

    );
  }

}

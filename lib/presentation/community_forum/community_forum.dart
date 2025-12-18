import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_chips_widget.dart';
import './widgets/create_post_sheet.dart';
import './widgets/post_card_widget.dart';
import './widgets/post_context_menu.dart';

class CommunityForum extends StatefulWidget {
  const CommunityForum({super.key});

  @override
  State<CommunityForum> createState() => _CommunityForumState();
}

class _CommunityForumState extends State<CommunityForum>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _selectedCategory = 'Questions';
  bool _isRefreshing = false;
  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> _filteredPosts = [];

  final List<String> _categories = [
    'Questions',
    'Succès',
    'Prix du marché',
    'Météo',
    'Nuisibles',
    'Soins des cultures',
  ];

  @override
  void initState() {
    super.initState();
    _initializePosts();
    _filterPosts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializePosts() {
    _posts = [
      {
        "id": 1,
        "title": "Problème de jaunissement sur mes plants de maïs",
        "content":
            "Bonjour à tous, j'ai remarqué que les feuilles de mes plants de maïs commencent à jaunir. Est-ce que quelqu'un a déjà eu ce problème ? Que puis-je faire pour traiter cela naturellement ?",
        "author": "Jean Mballa",
        "location": "Douala, Cameroun",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "cropTag": "Maïs",
        "timestamp": DateTime.now().subtract(Duration(hours: 2)),
        "imageUrl":
            "https://images.pexels.com/photos/2132250/pexels-photo-2132250.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "hasVoiceNote": false,
        "likeCount": 12,
        "replyCount": 8,
        "shareCount": 3,
        "isLiked": false,
        "isExpert": false,
        "category": "Questions",
      },
      {
        "id": 2,
        "title": "Excellente récolte de cacao cette saison !",
        "content":
            "Je voulais partager ma joie avec la communauté. Grâce aux conseils reçus ici l'année dernière sur la taille et l'espacement, j'ai eu une récolte exceptionnelle de cacao. Merci à tous !",
        "author": "Marie Nkomo",
        "location": "Bafoussam, Cameroun",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "cropTag": "Cacao",
        "timestamp": DateTime.now().subtract(Duration(hours: 5)),
        "imageUrl":
            "https://images.pexels.com/photos/4022092/pexels-photo-4022092.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "hasVoiceNote": true,
        "likeCount": 28,
        "replyCount": 15,
        "shareCount": 7,
        "isLiked": true,
        "isExpert": false,
        "category": "Succès",
      },
      {
        "id": 3,
        "title": "Prix du manioc au marché de Yaoundé",
        "content":
            "Le prix du manioc a augmenté cette semaine au marché central de Yaoundé. 1500 FCFA le sac de 50kg contre 1200 FCFA la semaine dernière. Quelqu'un sait pourquoi cette hausse ?",
        "author": "Dr. Paul Essomba",
        "location": "Yaoundé, Cameroun",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "cropTag": "Manioc",
        "timestamp": DateTime.now().subtract(Duration(hours: 8)),
        "imageUrl": null,
        "hasVoiceNote": false,
        "likeCount": 18,
        "replyCount": 22,
        "shareCount": 12,
        "isLiked": false,
        "isExpert": true,
        "category": "Prix du marché",
      },
      {
        "id": 4,
        "title": "Alerte météo : fortes pluies prévues",
        "content":
            "Attention aux agriculteurs de la région du Centre ! Météo Cameroun annonce de fortes pluies pour les 3 prochains jours. Protégez vos jeunes plants et vérifiez vos systèmes de drainage.",
        "author": "Agrométéo Cameroun",
        "location": "Yaoundé, Cameroun",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "cropTag": null,
        "timestamp": DateTime.now().subtract(Duration(hours: 12)),
        "imageUrl":
            "https://images.pexels.com/photos/1118873/pexels-photo-1118873.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "hasVoiceNote": false,
        "likeCount": 45,
        "replyCount": 8,
        "shareCount": 28,
        "isLiked": true,
        "isExpert": true,
        "category": "Météo",
      },
      {
        "id": 5,
        "title": "Invasion de chenilles sur mes tomates",
        "content":
            "Mes plants de tomates sont attaqués par des chenilles vertes. J'ai essayé le savon noir mais ça ne marche pas bien. Quelqu'un a une solution bio efficace ?",
        "author": "Françoise Atangana",
        "location": "Bertoua, Cameroun",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "cropTag": "Tomate",
        "timestamp": DateTime.now().subtract(Duration(days: 1)),
        "imageUrl":
            "https://images.pexels.com/photos/1327838/pexels-photo-1327838.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "hasVoiceNote": true,
        "likeCount": 16,
        "replyCount": 11,
        "shareCount": 4,
        "isLiked": false,
        "isExpert": false,
        "category": "Nuisibles",
      },
      {
        "id": 6,
        "title": "Technique de paillage pour les bananiers",
        "content":
            "Je partage avec vous ma technique de paillage pour les bananiers plantains. Utilisez les feuilles mortes et les résidus de récolte. Cela garde l'humidité et nourrit le sol naturellement.",
        "author": "Ing. Samuel Fouda",
        "location": "Kribi, Cameroun",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "cropTag": "Banane Plantain",
        "timestamp": DateTime.now().subtract(Duration(days: 2)),
        "imageUrl":
            "https://images.pexels.com/photos/5966630/pexels-photo-5966630.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "hasVoiceNote": false,
        "likeCount": 34,
        "replyCount": 19,
        "shareCount": 15,
        "isLiked": true,
        "isExpert": true,
        "category": "Soins des cultures",
      },
    ];
  }

  void _filterPosts() {
    setState(() {
      if (_selectedCategory == 'Questions') {
        _filteredPosts = _posts
            .where((post) =>
                (post["category"] as String)
                    .toLowerCase()
                    .contains('question') ||
                (post["content"] as String).contains('?'))
            .toList();
      } else {
        _filteredPosts = _posts
            .where((post) => (post["category"] as String) == _selectedCategory)
            .toList();
      }
    });
  }

  void _searchPosts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filterPosts();
      } else {
        _filteredPosts = _posts
            .where((post) =>
                (post["title"] as String)
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                (post["content"] as String)
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                (post["author"] as String)
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                (post["cropTag"] as String? ?? '')
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    // Add a new mock post at the beginning
    final newPost = {
      "id": DateTime.now().millisecondsSinceEpoch,
      "title": "Nouvelle discussion ajoutée",
      "content":
          "Ceci est une nouvelle publication ajoutée lors du rafraîchissement. Elle simule l'arrivée de nouveau contenu dans le forum communautaire.",
      "author": "Nouvel Utilisateur",
      "location": "Garoua, Cameroun",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "cropTag": "Riz",
      "timestamp": DateTime.now(),
      "imageUrl": null,
      "hasVoiceNote": false,
      "likeCount": 0,
      "replyCount": 0,
      "shareCount": 0,
      "isLiked": false,
      "isExpert": false,
      "category": "Questions",
    };

    setState(() {
      _posts.insert(0, newPost);
      _isRefreshing = false;
    });

    _filterPosts();
  }

  void _createPost(Map<String, dynamic> newPost) {
    setState(() {
      _posts.insert(0, newPost);
    });
    _filterPosts();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Publication créée avec succès !'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _toggleLike(Map<String, dynamic> post) {
    setState(() {
      final isLiked = post["isLiked"] as bool;
      post["isLiked"] = !isLiked;
      post["likeCount"] = (post["likeCount"] as int) + (isLiked ? -1 : 1);
    });
  }

  void _showPostDetails(Map<String, dynamic> post) {
    Navigator.pushNamed(
      context,
      '/post-details',
      arguments: post,
    );
  }

  void _showPostContextMenu(Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PostContextMenu(
        post: post,
        onSave: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Publication sauvegardée'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        },
        onFollow: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vous suivez maintenant cette discussion'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        },
        onShare: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Publication partagée'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        },
      ),
    );
  }

  void _showCreatePostSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreatePostSheet(
        onPostCreated: _createPost,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forum Communautaire',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: _CommunitySearchDelegate(
                  posts: _posts,
                  onPostSelected: _showPostDetails,
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'search',
              size: 24,
              color: theme.appBarTheme.foregroundColor ??
                  theme.colorScheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: _showCreatePostSheet,
            icon: CustomIconWidget(
              iconName: 'edit',
              size: 24,
              color: theme.appBarTheme.foregroundColor ??
                  theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          CategoryChipsWidget(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
              _filterPosts();
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshPosts,
              color: theme.colorScheme.primary,
              child: _filteredPosts.isEmpty
                  ? _buildEmptyState(theme)
                  : ListView.builder(
                      controller: _scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: _filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = _filteredPosts[index];
                        return PostCardWidget(
                          post: post,
                          onTap: () => _showPostDetails(post),
                          onLongPress: () => _showPostContextMenu(post),
                          onLike: () => _toggleLike(post),
                          onShare: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Publication partagée'),
                                backgroundColor: theme.colorScheme.primary,
                              ),
                            );
                          },
                          onReply: () => _showPostDetails(post),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePostSheet,
        child: CustomIconWidget(
          iconName: 'add',
          size: 24,
          color:
              theme.floatingActionButtonTheme.foregroundColor ?? Colors.white,
        ),
        tooltip: 'Créer une publication',
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                    theme, 'home', 'Accueil', false, '/home-dashboard'),
                _buildNavItem(
                    theme, 'eco', 'Cultures', false, '/crop-database'),
                _buildNavItem(
                    theme, 'forum', 'Communauté', true, '/community-forum'),
                _buildNavItem(
                    theme, 'person', 'Profil', false, '/user-profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(ThemeData theme, String iconName, String label,
      bool isSelected, String route) {
    return Expanded(
      child: GestureDetector(
        onTap: isSelected
            ? null
            : () => Navigator.pushReplacementNamed(context, route),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: iconName,
                size: 24,
                color: isSelected
                    ? theme.bottomNavigationBarTheme.selectedItemColor
                    : theme.bottomNavigationBarTheme.unselectedItemColor,
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? theme.bottomNavigationBarTheme.selectedItemColor
                      : theme.bottomNavigationBarTheme.unselectedItemColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'forum',
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          SizedBox(height: 2.h),
          Text(
            'Aucune discussion trouvée',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Soyez le premier à partager dans cette catégorie',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton.icon(
            onPressed: _showCreatePostSheet,
            icon: CustomIconWidget(
              iconName: 'add',
              size: 20,
              color: theme.colorScheme.onPrimary,
            ),
            label: Text('Créer une publication'),
          ),
        ],
      ),
    );
  }
}

class _CommunitySearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> posts;
  final Function(Map<String, dynamic>) onPostSelected;

  _CommunitySearchDelegate({
    required this.posts,
    required this.onPostSelected,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: CustomIconWidget(
          iconName: 'clear',
          size: 24,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: CustomIconWidget(
        iconName: 'arrow_back',
        size: 24,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final theme = Theme.of(context);
    final results = posts
        .where((post) =>
            (post["title"] as String)
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            (post["content"] as String)
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            (post["author"] as String)
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            (post["cropTag"] as String? ?? '')
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: 2.h),
            Text(
              'Aucun résultat trouvé',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Essayez avec d\'autres mots-clés',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final post = results[index];
        return ListTile(
          leading: Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: post["avatar"] as String,
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            post["title"] as String,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post["author"] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              if (post["cropTag"] != null)
                Container(
                  margin: EdgeInsets.only(top: 0.5.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    post["cropTag"] as String,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
          onTap: () {
            close(context, '');
            onPostSelected(post);
          },
        );
      },
    );
  }
}

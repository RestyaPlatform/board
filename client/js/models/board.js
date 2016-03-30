if (typeof App === 'undefined') {
    App = {};
}
/**
 * Board Model
 * @class Board
 * @constructor
 * @extends Backbone.Model
 */
App.Board = Backbone.Model.extend({
    url: function() {
        return api_url + 'boards/' + this.id + '.json';
    },
    storeName: 'board',
    initialize: function(args) {
        this.lists = new App.ListCollection();
        this.lists.url = api_url + 'boards/' + this.id + '/lists.json';
        this.lists.board = this;

        this.board_subscribers = new App.BoardSubscriberCollection();
        this.board_subscribers.url = api_url + 'boards/' + this.id + '/board_subscribers.json';
        this.board_subscribers.board = this;

        this.board_stars = new App.BoardSubscriberCollection();
        this.board_stars.board = this;

        this.activities = new App.ActivityCollection();
        this.activities.url = api_url + 'boards/' + this.id + '/activities.json';
        this.activities.board = this;

        this.board_subscriber = new App.BoardSubscriber();
        this.board_subscriber.url = api_url + 'boards/' + this.id + '/subscriber.json';
        this.board_subscriber.board = this;

        this.board_star = new App.BoardStar();
        this.board_star.url = api_url + 'boards/' + this.id + '/subscriber.json';
        this.board_star.board = this;

        this.board_users = new App.BoardsUserCollection();
        this.board_users.url = api_url + 'boards/' + this.id + '/users.json';
        this.board_users.board = this;

        this.custom_attachments = new App.CardAttachmentCollection();

        this.attachments = new App.CardAttachmentCollection();

        this.cards = new App.CardCollection();
        this.labels = new App.CardLabelCollection();
        this.checklists = new App.CardCheckListCollection();
        this.checklist_items = new App.CheckListItemCollection();
        this.boards_stars = new App.BoardStarCollection();
        this.acl_links = new App.AclBoardLinksCollection();
    }
});

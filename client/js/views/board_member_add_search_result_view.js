/**
 * @fileOverview This file has functions related to board member add search result view. This view calling from board header view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model. It contain all board based object @see Available Object in App.BoardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * BoardMemberAddSearchResult View
 * @class BoardMemberAddSearchResultView
 * @constructor
 * @extends Backbone.View
 */
App.BoardMemberAddSearchResultView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.board = options.board;
        this.render();
    },
    template: JST['templates/board_member_add_search_result'],
    tagName: 'a',
    className: 'js-add-board-member cur row clearfix',
    events: {
        'click': 'addBoardMember',
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            user: this.model
        }));
        this.showTooltip();
        return this;
    },
    addBoardMember: function() {
        var board_user = new App.BoardsUser();
        var self = this;
        board_user.set('board_id', this.board.attributes.id);
        board_user.set('user_id', this.model.attributes.id);
        board_user.set('board_user_role_id', 2);
        board_user.set(this.model.toJSON());
        delete board_user.attributes.id;
        this.$el.remove();
        board_user.url = api_url + 'boards/' + this.board.attributes.id + '/users.json';
        board_user.save({
            user_id: this.model.attributes.id,
            board_id: this.board.attributes.id,
            board_user_role_id: 2
        }, {
            success: function(model, response) {
                response.boards_users.board_user_role_id = 2;
                response.boards_users.user_id = parseInt(response.boards_users.user_id);
                board_user.set(response.boards_users);
                self.board.board_users.add(board_user);
            }
        });
        return false;
    }
});

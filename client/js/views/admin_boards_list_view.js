/**
 * @fileOverview This file has functions related to user view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Admin Boards List View
 * @class AdminBoardsListView
 * @constructor
 * @extends Backbone.View
 */
App.AdminBoardsListView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.render();
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.updateCollection();
    },
    updateCollection: function() {
        var _this = this;
        _this.current_page = (!_.isUndefined(_this.current_page)) ? _this.current_page : 1;
        _this.boards = new App.BoardCollection();
        $('.js-my-boards').html('<tr class="js-loader"><td colspan="12"><span class="cssloader"></span></td></tr>');
        _this.boards.url = api_url + 'boards.json?page=' + _this.current_page;
        app.navigate('#/' + 'boards/list?page=' + _this.current_page, {
            trigger: false,
            trigger_function: false,
        });
        _this.boards.fetch({
            cache: false,
            abortPending: true,
            success: function(boards, response) {
                _this.headerView = new App.HeaderView({
                    model: authuser,
                    boards: boards
                });
                $('#header').html(_this.headerView.el);
                $('#js-navbar-default').remove();
                var view = $('#content').html(new App.AdminBoardsIndexView({
                    filter_count: response.filter_count
                }).el);
                boards.each(function(board) {
                    $('.js-my-boards').append(new App.AdminBoardView({
                        model: board,
                        board_user_roles: response.board_user_roles
                    }).el);
                });
                $('.js-my-boards').find('.timeago').timeago();
                $('.pagination-boxes').unbind();
                $('.pagination-boxes').pagination({
                    total_pages: response._metadata.noOfPages,
                    current_page: _this.current_page,
                    display_max: 4,
                    callback: function(event, page) {
                        event.preventDefault();
                        if (page) {
                            _this.current_page = page;
                            _this.updateCollection();
                        }
                    }
                });
            }
        });
    }
});

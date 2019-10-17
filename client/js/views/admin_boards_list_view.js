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
        if (!_.isUndefined(options.page) && options.page !== null) {
            var page_no;
            if (options.page.indexOf('filter') !== -1) {
                var query_param = options.page.split('&filter=');
                page_no = query_param[0].replace('page=', '');
                this.current_page = page_no + '&filter=' + query_param[1];
                this.current_param = query_param[1];
            } else {
                page_no = options.page.split('page=');
                this.current_page = page_no[1];
                this.current_param = 'all';
            }
        } else {
            this.current_page = 1;
            this.current_param = 'all';
        }
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
        _this.pagination = (!_.isUndefined(_this.pagination)) ? _this.pagination : 1;
        _this.boards = new App.BoardCollection();
        $('.js-my-boards').html('<tr class="js-loader"><td colspan="12"><span class="cssloader"></span></td></tr>');
        _this.boards.url = api_url + 'boards.json?page=' + _this.current_page;
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
                $('#content').html(new App.AdminBoardsIndexView({
                    model: boards,
                    filter_count: response.filter_count,
                    'current_param': _this.current_param,
                    'current_page': _this.current_page
                }).el);
                boards.each(function(board) {
                    $('.js-my-boards').append(new App.AdminBoardView({
                        model: board,
                        board_user_roles: response.board_user_roles
                    }).el);
                });
                $('.pagination-boxes').unbind();
                $('.pagination-boxes').html('');
                if (!_.isUndefined(response._metadata) && parseInt(response._metadata.noOfPages) > 1) {
                    $('.pagination-boxes').pagination({
                        total_pages: parseInt(response._metadata.noOfPages),
                        current_page: parseInt(_this.current_page),
                        display_max: 4,
                        callback: function(event, page) {
                            event.preventDefault();
                            if (page) {
                                _this.pagination = 2;
                                if (!_.isUndefined(_this.current_param) && _this.current_param !== null && _this.current_param !== 'all') {
                                    _this.current_page = page + '&filter=' + _this.current_param;
                                    page = _this.current_page;
                                } else {
                                    _this.current_page = page;
                                }
                                app.navigate('#/' + 'boards/list?page=' + page, {
                                    trigger: true,
                                    trigger_function: true,
                                });
                            }
                        }
                    });
                }
            }
        });
    }
});

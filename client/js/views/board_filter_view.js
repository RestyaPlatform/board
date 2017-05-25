/**
 * @fileOverview This file has functions related to board filter view. This view calling from board header view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model. It contain all board based object @see Available Object in App.BoardView
 *	this.model.labels				: labels collection
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * BoardFilter View
 * @class BoardFilterView
 * @constructor
 * @extends Backbone.View
 */
App.BoardFilterView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.labels = options.labels;
        this.render();
    },
    template: JST['templates/board_filter'],
    tagName: 'li',
    converter: new showdown.Converter(),
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            board: this.model,
            board_labels: this.labels,
            converter: this.converter
        }));
        this.showTooltip();
        this.filterBoard();
        return this;
    },
    /**
     * filterBoard()
     * toggle board filter list
     * @param e
     * @type Object(DOM event)
     *
     */
    filterBoard: function(e) {
        var self = this;
        localforage.getItem('board_filter', function(err, value) {
            if (value) {
                var current_param = Backbone.history.fragment.split('?');
                var current_url = current_param[0].split('/');
                var filter = 'grid';
                if (current_url.length === 3 && current_url[2] == 'list') {
                    filter = 'list';
                } else if (current_url.length === 3 && current_url[2] == 'gantt') {
                    filter = 'gantt';
                }
                var arrays = [];
                var filter_label_arr = (value.label.name) ? value.label.name : [];
                var result_label_arr = (value.label.filter) ? value.label.filter : [];
                var filter_user_arr = (value.user.name) ? value.user.name : [];
                var result_user_arr = (value.user.filter) ? value.user.filter : [];
                var filter_due_arr = (value.due.name) ? value.due.name : [];
                var result_due_arr = (value.due.filter) ? value.due.filter : [];
                /* jshint ignore:start */
                if (!_.isEmpty(filter_label_arr)) {
                    for (i = 0; i < filter_label_arr.length; i++) {
                        self.$el.find('.js-board-labels > li').each(function(index) {
                            if (($(this).find('.js-label').text() === filter_label_arr[i]) && ($(this).find('.js-label').next('i').length === 0)) {
                                $(this).append('<i class="icon-ok js-filter-icon cur pull-right"></i>');
                            }
                        });
                    }
                }
                if (!_.isEmpty(filter_user_arr)) {
                    for (i = 0; i < filter_user_arr.length; i++) {
                        self.$el.find('.js-board-users > li').each(function(index) {
                            if (($(this).find('.js-user').text() === filter_user_arr[i]) && ($(this).find('.js-user').next('i').length === 0)) {
                                $(this).find('.media').append('<i class="icon-ok js-filter-icon cur pull-right"></i>');
                            }
                        });
                    }
                }
                if (!_.isEmpty(filter_due_arr)) {
                    for (i = 0; i < filter_due_arr.length; i++) {
                        self.$el.find('.js-board-dues > li').each(function(index) {
                            if (($(this).find('.js-due').text() === filter_due_arr[i]) && ($(this).find('.js-due').next('i').length === 0)) {
                                $(this).append('<i class="icon-ok js-filter-icon cur pull-right"></i>');
                            }
                        });
                    }
                }
                /* jshint ignore:end */
            }
        });
    }

});

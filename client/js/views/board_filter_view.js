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
    converter: new showdown.Converter({
        extensions: ['targetblank']
    }),
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.converter.setFlavor('github');
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
        this.$el.find('.js-clear-filter-btn').removeClass('hide').addClass('show');
        var filter_label_arr = [],
            filter_user_arr = [],
            filter_due_arr = [];
        var current_param = Backbone.history.fragment.split('?');
        var current_url = current_param[0].split('/');
        var filter = 'grid';
        if (current_url.length === 3 && current_url[2] == 'list') {
            filter = 'list';
        } else if (current_url.length === 3 && current_url[2] == 'gantt') {
            filter = 'gantt';
        }
        if (current_param[1]) {
            var query_params = current_param[1].split(',');
            query_params[0] = query_params[0].replace('filter=', '');
            $.each(query_params, function(index, value) {
                if (value.indexOf('label:') > -1) {
                    filter_label_arr.push(value.replace('label:', ''));
                } else if (value.indexOf('@') > -1) {
                    filter_user_arr.push(value.replace('@', ''));
                } else if (value.indexOf('due:') > -1) {
                    filter_due_arr.push(value.replace('due:', ''));
                }
            });
            /* jshint ignore:start */
            if (!_.isEmpty(filter_label_arr)) {
                for (i = 0; i < filter_label_arr.length; i++) {
                    self.$el.find('.js-board-labels > li').each(function(index) {
                        if (($(this).find('.js-label').text() === filter_label_arr[i]) && ($(this).find('.js-label').next('i').length === 0)) {
                            $(this).append('<i class="icon-ok js-filter-icon cur pull-right"></i>');
                            $(this).addClass('selected');
                        }
                    });
                }
            }
            if (!_.isEmpty(filter_user_arr)) {
                for (i = 0; i < filter_user_arr.length; i++) {
                    self.$el.find('.js-board-users > li').each(function(index) {
                        if (($(this).find('.js-user').parent().data('user') === filter_user_arr[i]) && ($(this).find('.js-user').next('i').length === 0)) {
                            $(this).find('.media').append('<i class="icon-ok js-filter-icon cur pull-right"></i>');
                            $(this).addClass('selected');
                        }
                    });
                }
            }
            if (!_.isEmpty(filter_due_arr)) {
                for (i = 0; i < filter_due_arr.length; i++) {
                    self.$el.find('.js-board-dues > li').each(function(index) {
                        if (($(this).find('.js-due').text() === filter_due_arr[i]) && ($(this).find('.js-due').next('i').length === 0)) {
                            $(this).append('<i class="icon-ok js-filter-icon cur pull-right"></i>');
                            $(this).addClass('selected');
                        }
                    });
                }
            }
            /* jshint ignore:end */
        }
    }
});

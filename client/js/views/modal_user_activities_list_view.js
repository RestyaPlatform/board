/**
 * @fileOverview This file has functions related to modal user activities list view. This view calling from modal user actions view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Modal User Activities List View
 * @class ModalUserActivitiesListView
 * @constructor
 * @extends Backbone.View
 */
App.ModalUserActivitiesListView = Backbone.View.extend({
    id: 'base-modal',
    className: '',
    template: JST['templates/modal_user_activities_list_view'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-close-popover': 'closePopup',
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.user_id = options.user_id;
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        _(this).bindAll('show', 'teardown');
    },
    teardown: function() {
        this.$el.data('modal', null);
        this.remove();
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
            list: this.model
        }));
        this.renderUserActivitiesCollection();
        this.$el.modal({
            show: true,
            backdrop: false
        });
        this.showTooltip();
        return this;
    },
    /**
     * show()
     * display list attachment
     */
    show: function() {
        this.render();
        this.$el.find('#modalUserActivitiesListView').modal('show');
    },
    /**
     * closePopup()
     * close opened dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        return false;
    },
    /**
     * renderUserActivitiesCollection()
     * render activities
     */
    renderUserActivitiesCollection: function() {
        var view_user_activities = this.$('#js-list-user-activities-list');
        view_user_activities.html('');
        var activities = new App.ActivityCollection();
        activities.url = api_url + 'users/' + this.user_id + '/activities.json?board_id=' + this.model.attributes.board_id;
        activities.fetch({
            success: function(response) {
                if (activities.length > 0) {
                    activities.each(function(activity) {
                        activity.from_footer = true;
                        var view = new App.ActivityView({
                            model: activity
                        });
                        view_user_activities.append(view.render().el).find('.timeago').timeago();
                    });
                } else {
                    var view = new App.ActivityView({
                        model: null
                    });
                    view_user_activities.append(view.render().el);
                }
            }
        });
    }
});

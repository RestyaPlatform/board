/**
 * @fileOverview This file has functions related to user dashboard view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * UserDashboard View
 * @class UserDashboardView
 * @constructor
 * @extends Backbone.View
 */
App.UserDashboardView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        this.render();
    },
    events: {
        'click .dashboard-search': 'dashboardSearch'
    },
    template: JST['templates/user_dashboard'],
    tagName: 'section',
    className: 'clearfix',
    id: 'boards-index',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        var dashboard_data = {};
        this.$el.html(this.template({
            page_title: this.model,
        }));
        /*The IntroView has been called here*/
        var introView = new App.intro_video_view();
        this.showTooltip();
        return this;
    }
});

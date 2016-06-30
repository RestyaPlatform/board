/**
 * @fileOverview This file has functions related to show all visibility view. This view calling from board add view, board header view and board view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: visibility(String).
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ShowSyncGoogleCalendar View
 * @class ShowSyncGoogleCalendarView
 * @constructor
 * @extends Backbone.View
 */
App.ShowSyncGoogleCalendarView = Backbone.View.extend({
    tagName: 'li',
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/show_sync_google_calendar'],
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            url: this.model.attributes.google_syn_url,
        }));
        this.$el.find('input.js-syn-calendar-response').val(this.model.attributes.google_syn_url);
        this.showTooltip();
        return this;
    }
});

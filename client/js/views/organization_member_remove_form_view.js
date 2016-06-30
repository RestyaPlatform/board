/**
 * @fileOverview This file has functions related to organization member permission form view. This view calling from organization user view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: organizations user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * OrganizationMemberRemoveForm View
 * @class OrganizationMemberRemoveFormView
 * @constructor
 * @extends Backbone.View
 */
App.OrganizationMemberRemoveFormView = Backbone.View.extend({
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
    template: JST['templates/organization_member_remove_form'],
    tagName: 'li',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.el = this.template({
            organization_users: this.model
        });
        this.delegateEvents(this.events);
        this.showTooltip();
        return this;
    }
});

/**
 * @fileOverview This file has functions related to organizations lists header view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: organizations collection.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * OrganizationsUser View
 * @class OrganizationsUserView
 * @constructor
 * @extends Backbone.View
 */
App.OrganizationsListsView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.sortField = options.sortField;
        this.sortDirection = options.sortDirection;
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/organizations_lists_view'],
    tagName: 'section',
    className: 'row',
    id: 'js-organizations_lists',
    attributes: {
        role: 'navigation'
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
            organization: this.model
        }));
        this.renderOrganizationCollection();
        this.showTooltip();
        return this;
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    renderOrganizationCollection: function() {
        var view = this.$el.find('#js-organizations-list');
        if (!_.isEmpty(this.model.models)) {
            this.model.setSortField(this.sortField, this.sortDirection);
            this.model.sort();
            this.model.each(function(organization) {
                view.append(new App.OrganizationsListView({
                    model: organization
                }).el);
            });
        } else {
            view.html(new App.OrganizationsListView({
                model: null
            }).el);
        }
        return this;
    }
});

/**
 * @fileOverview This file has functions related to organization header view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: organization model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Header View
 * @class HeaderView
 * @constructor
 * @extends Backbone.View
 */
App.OrganizationHeaderView = Backbone.View.extend({
    template: JST['templates/organization_header'],
    id: 'js-navbar-default',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-close-popover': 'closePopup',
        'click #js-edit-organization': 'editOrganization',
        'click .js-delete-organization': 'deleteOrganization',
        'click .js-show-organization-visibility-form': 'showOrganizationVisibilityForm',
        'click .js-edit-organization-visibility-to-private': 'editOrganizationVisibilityToPrivate',
        'click .js-edit-organization-visibility-to-public': 'editOrganizationVisibilityToPublic',
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.model.bind('change:name change:organization_visibility', this.render, this);
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
        this.$el.html(this.template({
            organization: this.model,
            type: this.type
        }));
        this.showTooltip();
        return this;
    },
    /**
     * closePopup()
     * close opened dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        this.render();
        return false;
    },
    /**
     * editOrganization()
     * update organization
     * @return false
     */
    editOrganization: function(e) {
        var data = $('form#OrganizationEditForm').serializeObject();
        $('.error-msg').remove();
        $('.error-msg-description').remove();
        if (!$.trim($('#inputOrganizationName').val()).length) {
            $('<div class="error-msg text-primary h6">' + i18next.t('Whitespace is not allowed') + '</div>').insertAfter('#inputOrganizationName');
        }
        if ($.trim(data.description) === '') {
            $('<div class="error-msg-description text-primary h6">' + i18next.t('Whitespace is not allowed') + '</div>').insertAfter('#inputOrganizationDescription');
        }
        if ($.trim(data.description) !== '' && $.trim(data.name) !== '') {
            $('.error-msg').remove();
            e.preventDefault();
            var self = this.model;
            this.closePopup(e);
            this.model.set(data);
            this.model.url = api_url + 'organizations/' + this.model.organization_id + '.json';
            this.model.save(data, {
                patch: true,
                success: function(model, response) {
                    var organization = auth_user_organizations.findWhere({
                        id: parseInt(model.id)
                    });
                    if (!_.isEmpty(organization)) {
                        organization.set("name", data.name);
                    }
                }
            });
        }
        return false;
    },
    /**
     * deleteOrganization()
     * delete organization
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    deleteOrganization: function(e) {
        e.preventDefault();
        var organization = new App.Organization();
        organization.url = api_url + 'organizations/' + this.model.organization_id + '.json';
        organization.set('id', this.model.organization_id);
        organization.destroy();
        this.flash('success', i18next.t('Organization deleted successfully.'));
        app.navigate('#/organizations', {
            trigger: true,
            replace: true
        });
        return false;
    },
    /**
     * showOrganizationVisibilityForm()
     * display organization visibility
     */
    showOrganizationVisibilityForm: function() {
        $('.js-organization-visibility').html(new App.OrganizationVisibilityFormView({
            model: this.model
        }).el);
    },
    /**
     * editOrganizationVisibilityToPublic()
     * update organization visibility
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    editOrganizationVisibilityToPublic: function(e) {
        $('.js-org-visibility-icon').removeClass('icon-lock');
        $('.js-org-visibility-icon').addClass('icon-circle');
        $('.js-org-visibility-type').html('Public');
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        this.model.url = api_url + 'organizations/' + this.model.id + '.json';
        this.model.set('organization_visibility', 1);
        this.model.save({
            organization_visibility: 1
        }, {
            patch: true
        });
        return false;
    },
    /**
     * editOrganizationVisibilityToPrivate()
     * change organization visibility as private
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    editOrganizationVisibilityToPrivate: function(e) {
        $('.js-org-visibility-icon').removeClass('icon-circle');
        $('.js-org-visibility-icon').addClass('icon-lock');
        $('.js-org-visibility-type').html('Private');
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        this.model.url = api_url + 'organizations/' + this.model.organization_id + '.json';
        this.model.set('organization_visibility', 2);
        this.model.save({
            organization_visibility: 2
        }, {
            patch: true
        });
        return false;
    }
});

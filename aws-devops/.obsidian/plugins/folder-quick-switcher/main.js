"use strict";

const { FuzzySuggestModal, Notice, Plugin, TFolder } = require("obsidian");

class FolderQuickSwitcherPlugin extends Plugin {
  async onload() {
    this.addCommand({
      id: "open-folder-quick-switcher",
      name: "Open folder quick switcher",
      callback: () => {
        new FolderQuickSwitcherModal(this.app).open();
      },
    });
  }
}

class FolderQuickSwitcherModal extends FuzzySuggestModal {
  constructor(app) {
    super(app);
    this.setPlaceholder("Search folders by name or path...");
  }

  getItems() {
    return getAllFolders(this.app.vault.getRoot()).sort((a, b) =>
      a.path.localeCompare(b.path)
    );
  }

  getItemText(folder) {
    return folder.path;
  }

  renderSuggestion(item, element) {
    const folder = item.item;
    element.addClass("folder-quick-switcher-suggestion");

    const name = element.createDiv({
      cls: "folder-quick-switcher-suggestion-name",
      text: folder.name || folder.path,
    });
    name.setAttr("title", folder.path);

    element.createDiv({
      cls: "folder-quick-switcher-suggestion-path",
      text: folder.path,
    });
  }

  async onChooseItem(folder) {
    const revealed = await revealFolderInFileExplorer(this.app, folder);

    if (!revealed) {
      new Notice(`Folder selected: ${folder.path}`);
    }
  }
}

function getAllFolders(rootFolder) {
  const folders = [];

  collectChildFolders(rootFolder, folders);

  return folders;
}

function collectChildFolders(folder, folders) {
  for (const child of folder.children || []) {
    if (!isFolder(child)) {
      continue;
    }

    folders.push(child);
    collectChildFolders(child, folders);
  }
}

function isFolder(file) {
  return file instanceof TFolder || Array.isArray(file.children);
}

async function revealFolderInFileExplorer(app, folder) {
  const leaf = await getOrCreateFileExplorerLeaf(app);
  if (!leaf) {
    return false;
  }

  app.workspace.setActiveLeaf(leaf, { focus: true });

  const view = leaf.view;
  if (view && typeof view.revealInFolder === "function") {
    await view.revealInFolder(folder);
    focusFileExplorerItem(view, folder);
    return true;
  }

  return false;
}

async function getOrCreateFileExplorerLeaf(app) {
  const existingLeaf = app.workspace.getLeavesOfType("file-explorer")[0];
  if (existingLeaf) {
    return existingLeaf;
  }

  const leftLeaf = app.workspace.getLeftLeaf(false);
  if (!leftLeaf) {
    return null;
  }

  await leftLeaf.setViewState({ type: "file-explorer", active: true });
  return leftLeaf;
}

function focusFileExplorerItem(view, folder) {
  const fileItems = view.fileItems;
  const item = fileItems && fileItems[folder.path];

  if (!item) {
    return;
  }

  if (typeof view.setSelection === "function") {
    view.setSelection(item);
  }

  const element = item.selfEl || item.el;
  if (element && typeof element.scrollIntoView === "function") {
    element.scrollIntoView({ block: "center" });
  }
}

module.exports = FolderQuickSwitcherPlugin;
